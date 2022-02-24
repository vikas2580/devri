module BxBlockShoppingCart
  class Order < ApplicationRecord
    include Wisper::Publisher
    self.table_name = :shopping_cart_orders

    BUFFER_TIME = 20 #in minute

    #order status are
    #upcomming = 'scheduled', ongoing = 'on_going', history = 'cancelled or completed

    belongs_to :address, class_name: 'BxBlockAddress::Address'
    belongs_to :service_provider,
               class_name: 'AccountBlock::Account',
               foreign_key: :service_provider_id
    belongs_to :customer, class_name: 'AccountBlock::Account', foreign_key: :customer_id
    belongs_to :coupon, class_name: 'BxBlockCoupons::Coupon', optional: true
    has_one :booked_slot,
            class_name: "BxBlockAppointmentManagement::BookedSlot",
            dependent: :destroy

    has_and_belongs_to_many :sub_categories,
                            class_name: 'BxBlockCategories::SubCategory',
                            join_table: :order_services, foreign_key: :shopping_cart_order_id

    enum :order_type => { 'instant booking' => 0, 'advance booking' => 1 }

    validates_presence_of :booking_date, :slot_start_time, :total_fees, :order_type
    validate :check_service_provide, if: Proc.new {|a|a.new_record?}
    validate :check_major_services, if: Proc.new {|a|a.new_record?}
    validate :check_available_slots, if: Proc.new {|a|a.new_record?}
    validate :check_order_status, if: Proc.new {|a| !a.new_record?}
    validate :instant_booking_slots,
             if: Proc.new { |order| order.order_type == 'instant booking' && order.new_record? }
    validate :advance_booking_slots,
             if: Proc.new { |order| order.order_type == 'advance booking' && order.new_record? }

    accepts_nested_attributes_for :sub_categories

    before_save :check_coupon_detail
    after_create :occupy_time_slot

    scope :todays_order, -> { where(slot_start_time: Date.today.strftime('%d/%m/%y')) }
    scope :completed_order, -> { where(status: 'completed') }

    def occupy_time_slot
      start_time = "#{(Time.parse(self.slot_start_time).strftime("%I:%M %p"))}"
      end_time = get_order_end_time.strftime("%I:%M %p")
      BxBlockAppointmentManagement::BookedSlot.create(
        order_id: self.id,
        start_time: start_time,
        end_time: end_time,
        service_provider_id: self.service_provider_id,
        booking_date: self.booking_date
      )
    end

    private

    #check slots for the instant booking
    def instant_booking_slots
      already_booked_slots = get_booked_slots
      order_start_time = (Time.parse(self.slot_start_time.to_s))
      mins = 0
      self.sub_categories.each do |sub_category|
        mins += sub_category.service_time.to_i
      end
      mins = mins.minute + BUFFER_TIME.minute #BUFFER TIME
      order_end_time = (Time.parse(self.slot_start_time) + mins)
      include_booked_time = false
      already_booked_slots.each do |slot|
        if (slot[:start_time]..slot[:end_time]).cover?(order_start_time) or
           (slot[:start_time]..slot[:end_time]).cover?(order_end_time)
          include_booked_time = true
          break
        end
      end
      errors.add(:invalid_time, 'Booking Slot not Available') if include_booked_time
      already_booked_slots
    end

    #check slots for the advance booking
    def advance_booking_slots
      return errors.add(
        :booking_date, 'You can not book service provider for today'
      ) if self.booking_date.today?

      availability = self.service_provider.availabilities.find_by_availability_date(
        self.booking_date.strftime('%d/%m/%y')
      )

      return errors.add(
        :availability,
        "Service provider is unavailable for #{self.booking_date.strftime('%d/%m/%y')}"
      ) unless availability.present?

      slot_list = availability.slots_list
      slots_available?(slot_list)
    end

    #Get all booked slots
    def get_booked_slots
      BxBlockAppointmentManagement::BookedSlot.where(
        service_provider_id: self.service_provider.id,
        booking_date: self.booking_date
      ).map do |booked_slot|
        { start_time: booked_slot.start_time.to_time, end_time: booked_slot.end_time.to_time }
      end
    end

    def check_service_provide
      errors.add(
        :service_provider, 'Invalid service provider'
      ) unless self.service_provider.present? and is_merchant?
    end

    def check_coupon_detail
      unless self.is_coupon_applied
        self.coupon_id = nil
        self.discount = nil
      end
    end

    def check_order_status
      errors.add(
        :invalid_request, 'Your order is finished, you can not update it now'
      ) if self.status_was == 'completed'
    end

    def check_available_slots
      order_date = self.booking_date
      return errors.add(
        :slot_start_time, 'Please select any slot to book'
      ) unless self.slot_start_time.present?
      order_start_time = (Time.parse(self.slot_start_time.to_s))
      order_end_time = get_order_end_time
      service_provider_availability = BxBlockAppointmentManagement::Availability.find_by(
        service_provider_id: self.service_provider.id,
        availability_date: self.booking_date.strftime('%d/%m/%y')
      )
      return errors.add(
        :invalid_request,
        'Service Provider dose not set their time for the day'
      ) unless service_provider_availability.present?

      return errors.add(
        :invalid_time, 'Booking Slot not Available'
      ) unless service_provider_availability.present? or (
        service_provider_availability.start_time..service_provider_availability.end_time
      ).cover?(order_start_time) or (
        service_provider_availability.start_time..service_provider_availability.end_time
      ).cover?(order_end_time)

      unless check_availability_covers_order(
        service_provider_availability, order_start_time, order_end_time
      )
        return errors.add(:invalid_time, 'Booking Slot not Available')
      end
    end

    def get_order_end_time
      mins = 0
      self.sub_categories.each do |sub_category|
        mins += sub_category.service_time.to_i
      end
      mins = mins.minute + BUFFER_TIME.minute #BUFFER TIME
      (Time.parse(self.slot_start_time) + mins)
    end

    def check_availability_covers_order(availability, order_start_time, order_end_time)
      if availability.unavailable_start_time.present? &&
          availability.unavailable_end_time.present?
        unavailable_start_time = availability.unavailable_start_time.to_time
        unavailable_end_time = availability.unavailable_end_time.to_time
        unavailable_slot = (unavailable_start_time..unavailable_end_time)
      end

      if availability.unavailable_start_time.present? &&
          availability.unavailable_end_time.present? and
          (unavailable_slot.cover?(order_end_time) or unavailable_slot.cover?(order_start_time))
        return false
      end

      true
    end

    # Validation function to check the proper availability for the required slots.
    def slots_available?(availability_slots)
      availability = self.service_provider.availabilities.find_by(
        availability_date: self.booking_date.strftime("%d/%m/%y")
      )

      errors.add(
        :service_provider, "Service Provider is not available on the order placing date."
      ) and return if availability.blank?

      start_time, end_time = get_start_and_end_time
      time_slot = availability_slots.detect{
        |time| (Time.parse(time[:from]) == Time.parse(start_time) && time[:booked_status] == false)
      }
      greater_time_slots = []
      if time_slot.present?
        needed_time_slots = []
        if Time.parse(time_slot[:to]) < Time.parse(end_time)
          availability_slots.each do |time|
            if Time.parse(time[:from]) > Time.parse(start_time)
              unless time[:booked_status]
                if ((Time.parse(time[:from])..Time.parse(time[:to])).cover?(Time.parse(end_time)))
                  greater_time_slots << time
                end
              else
                errors.add(
                  :booking_slot,
                  'Your service timings are greater then available slots. May be next slots is ' \
                  'not available. Please try to book your services on any other slots having its ' \
                  'following slot empty.'
                )
              end
            end
          end
          greater_time_slots.push(time_slot)
          if greater_time_slots.count < 1
            errors.add(:booking_slot, 'Booking Slot not Available')
          end
        end
      else
        errors.add(:booking_slot, 'Booking Slot not Available')
      end
    end


    # Fetching the required slots
    def get_available_time_slots
      availability = self.service_provider.availabilities.find_by(
        availability_date: self.booking_date.strftime("%d/%m/%y")
      )
      start_time, end_time = get_start_and_end_time
      time_slot = availability.timeslots.detect{
        |time| (Time.parse(time[:from]) == Time.parse(start_time) && time[:booked_status] == false)
      }
      needed_time_slots = []
      greater_time_slots = []
      if Time.parse(time_slot[:to]) < Time.parse(end_time)
        availability.timeslots.each do |time|
          if Time.parse(time[:from]) > Time.parse(start_time)
            unless time[:booked_status]
              if ((Time.parse(time[:from])..Time.parse(time[:to])).cover?(Time.parse(end_time)))
                greater_time_slots << time
              end
            end
          end
        end
      end
      greater_time_slots.push(time_slot)
      greater_time_slots
    end

    # Updating the booked slots status as true
    def modify_occupied_time_slots(greater_time_slots)
      availability = self.service_provider.availabilities.find_by(
        availability_date: self.booking_date.strftime("%d/%m/%y")
      )
      availability_time_slots = availability.timeslots
      modified_time_slots = []

      greater_time_slots.each do |time_slot|
        availability_time_slots.delete_if {|slot| slot[:sno] == time_slot[:sno]}
        time_slot[:booked_status] = true
      end
      final_time_slots = availability_time_slots + greater_time_slots
      availability.update_column("timeslots", final_time_slots)
    end

    def get_start_and_end_time
      start_time = "#{(Time.parse(self.slot_start_time).strftime("%I:%M %p"))}"
      mins = 0
      self.sub_categories.each do |sub_category|
        mins += sub_category.service_time.to_i
      end
      mins = mins.minute + BUFFER_TIME.minute #BUFFER TIME
      end_time = (Time.parse(self.slot_start_time) + mins).strftime("%I:%M %p")
      [start_time, end_time]
    end

    #To check major service presence
    def check_major_services
      valid_order = false
      self.sub_categories.each do |a|
        if a.service_type == 'major'
          valid_order = true
          break
        end
      end
      valid_order
    end

    def update_slots_detail
      self.service_provider.availabilities
    end

    def is_merchant?
      role = BxBlockRolesPermissions::Role.find_by(id: self.service_provider.role_id)
      return false unless role
      role.name == 'Merchant'
    end
  end
end

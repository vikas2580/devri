module BxBlockShoppingCart
  class OrderSerializer < BuilderBase::BaseSerializer

    attributes *[
        :booking_date,
        :slot_start_time,
        :total_fees,
        :instructions,
        :service_total_time_minutes,
        :status,
        :is_coupon_applied,
        :ongoing_time,
        :finish_at,
        :notify_me,
    ]

    attribute :service_provider do |object|
      AccountBlock::AccountSerializer.new(object.service_provider)
    end

    attribute :customer do |object|
      AccountBlock::AccountSerializer.new(object.customer)
    end

    attribute :booked_slot do |object|
      BxBlockCalendar::BookedSlotSerializer.new(object.booked_slot)
    end

    attribute :van_location do |object|
      van_member = BxBlockLocation::VanMember.find_by_account_id(object.service_provider.id)
      van = BxBlockLocation::Van.find_by_id(van_member.van_id)
      BxBlockLocation::VanLocationSerializer.new(
        van.location
      ) if van&.location.present?
    end

    attribute :address do |object|
      BxBlockAddress::AddressSerializer.new(object.address)
    end

    attribute :services do |object|
      order_services_for object
    end

    attribute :coupon_detail do |object|
      object.is_coupon_applied ? object.coupon&.name : nil
    end

    class << self
      def order_services_for order
        order.sub_categories.pluck(:name)
        # order.services.map{|service| service.sub_category.name }
      end
    end
  end
end

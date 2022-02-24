module BxBlockShoppingCart
  class AvailabilitySerializer< BuilderBase::BaseSerializer

    attributes *[:service_provider_id,
                 :start_time,
                 :end_time,
                 :unavailable_start_time,
                 :unavailable_end_time,
                 :availability_date,
    ]
    attribute :booked_slots do |object, params|
      object.service_provider.booked_slots.where(
        booking_date: (Date.parse(params[:date]))
      ).map{
        |slot| {
          start_time: slot.start_time,
          end_time: slot.end_time,
          booking_date: slot.booking_date
        }
      } if params.present? && params[:date].present?
    end
  end
end

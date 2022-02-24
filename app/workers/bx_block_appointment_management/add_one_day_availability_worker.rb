module BxBlockAppointmentManagement
  #Create slot for 6 days in advance
  class AddOneDayAvailabilityWorker
    include Sidekiq::Worker

    def perform availability_id
      availability_for_id(availability_id)
      slot_for_today = BxBlockAppointmentManagement::Availability.find_by(
        service_provider_id: @availability.service_provider_id,
        availability_date: Date.today.strftime('%d/%m/%y')
      ).present?
      unless !@availability.present? and slot_for_today
        value = @availability.dup
        value.availability_date = date.strftime('%y/%m/%d')
        value.save!
        trriger_job
      end
    end

    def trriger_job
      BxBlockAppointmentManagement::AddOneDayAvailabilityWorker.perform_at(
        1.days.from_now, @availability.id
      )
    end

    def availability_for_id id
      @availability = BxBlockAppointmentManagement::Availability.find(id)
    end
  end
end

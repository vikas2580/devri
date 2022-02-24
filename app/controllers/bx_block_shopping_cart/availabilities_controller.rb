module BxBlockShoppingCart
  class AvailabilitiesController < ApplicationController
    before_action :get_service_provider, only: %i(get_booked_time_slots)

    def get_booked_time_slots
      unless params[:service_provider_id].blank? || params[:booking_date].blank?
        render json: BxBlockShoppingCart::OrderSerializer.new(
          BxBlockShoppingCart::Order.where(
            service_provider_id: params[:service_provider_id],
            booking_date: params[:booking_date].to_datetime
          ), meta: {
            availability: BxBlockAppointmentManagement::Availability.find_by(
              service_provider_id: @service_provider.id
            )
          }
        ).serializable_hash
      else
        render json: {errors: [
          {availability: 'Date or Service provider Account id is empty'},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def get_service_provider
      render json: {
        errors: 'Please enter service_provider'
      } and return unless params[:service_provider_id].present?
      @service_provider = AccountBlock::Account.find(params[:service_provider_id])
    end
  end
end

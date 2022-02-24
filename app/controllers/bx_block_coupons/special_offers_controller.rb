module BxBlockCoupons
  class SpecialOffersController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def show
      special_offer = BxBlockCoupons::ComboOffer.find(params[:id])
      render json: BxBlockCoupons::SpecialOfferSerializer.new(
        special_offer
      ).serializable_hash, status: :ok
    end

    def get_service_provider
      render json: {
        errors: 'Select any date to to get availability'
      } and return unless params[:date].present?
      service_provider = BxBlockAppointmentManagement::Availability.where(
        availability_date: Date.parse(params[:date]).strftime('%d/%m/%y')
      ).order(:available_slots_count)&.first&.service_provider
      render json: {
        errors: "No service provider is available for date:#{params[:date]}"
      } and return unless service_provider.present?
      render json: AccountBlock::AccountSerializer.new(
        service_provider
      ).serializable_hash, status: :ok
    end
  end
end

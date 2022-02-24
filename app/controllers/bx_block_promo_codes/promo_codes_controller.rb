module BxBlockPromoCodes
  class PromoCodesController < ApplicationController
    def index
      promo_codes = active_promocodes
      if promo_codes
        render json: PromoCodeSerializer.new(promo_codes)
      else
        render json: {
          errors: [{ promo_code: 'Promo code Not available for given criteria' }],
        }, status: :unprocessable_entity
      end
    end

    private

    def active_promocodes
      if params[:restaurant_id]
        promo_codes = BxBlockPromoCodes::PromoCode.joins(:restaurant_promo_codes).where(
          'restaurant_promo_codes.restaurant_id' => params[:restaurant_id]
        )
      elsif params[:account]
        promo_codes = BxBlockPromoCodes::PromoCode.joins(:account_promo_codes).where(
          'account_promo_codes.account_id' => params[:account_id]
        )
      elsif params[:mall]
        promo_codes = BxBlockPromoCodes::PromoCode.joins(:mall_promo_codes).where(
          'mall_promo_codes.account_id' => params[:mall_id]
        )
      end

      promo_codes ? promo_codes.available.active : nil
    end
  end
end

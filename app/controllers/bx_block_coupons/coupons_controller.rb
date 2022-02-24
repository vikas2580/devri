module BxBlockCoupons
  class CouponsController < ApplicationController
    def check_applicability
      discount = BxBlockCoupons::CouponApplicabilityCommand.check(
        @token.id, jsonapi_deserialize(params)
      )
      case discount.first
      when :unprocessable_entity
        render json: {
          errors: discount.second,
        }, status: :unprocessable_entity
      when :coupon_applied
        render json: {
          meta: {
            discount: discount.second,
            message: "Coupon is applicable",
            coupon_id: discount.third
          }
        }
      end
    end

    def get_refferal_coupon
      refferal_coupon = RefferalCoupon.last
      if refferal_coupon.present?
        render json: {meta: {refferal_coupon: refferal_coupon, message: "Refferal Coupon" }}
      else
        render json: { errors: ["Refferal Coupon not found."] }, status: :unprocessable_entity
      end
    end
  end
end

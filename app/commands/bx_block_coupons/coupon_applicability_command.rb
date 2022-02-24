module BxBlockCoupons
  module CouponApplicabilityCommand
    extend self

    def check(account_id, params)
      validator = BxBlockCoupons::CouponApplicabilityValidator.new(
        account_id, params['name'], params['order_amount']
      )
      return [:unprocessable_entity, validator.errors.full_messages] unless validator.valid?
      validator = validator.coupon
      # coupon = find_coupon params['name']
      discount_price = discount_amount(validator, params['order_amount'])
      return [:coupon_applied, discount_price, validator.id]
    end

    private

    def find_coupon name
      coupon = BxBlockCoupons::Coupon.find_by_name(name)
      return errors.add(:base, 'Invalid coupon') unless coupon.present?
    end

    def discount_amount coupon, order_amount
      discount = ((order_amount.to_i * coupon.discount.to_i) / 100) if coupon.coupon_type == 'up_to'
      discount = (coupon.max_discount) if coupon.coupon_type == 'flat'
    end
  end
end

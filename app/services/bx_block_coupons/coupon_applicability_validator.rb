module BxBlockCoupons
  class CouponApplicabilityValidator < BuilderBase::BaseSerializer
    include ActiveModel::Validations

    attr_accessor(*[
      :account,
      :name,
      :order_amount,
    ])

    validates :name, presence: {message: 'Enter a coupon please'}
    validate :coupon
    validate :validate_min_order_amount

    def initialize(account_id, name, order_amount)
      @account_id = account_id
      @name = name
      @order_amount = order_amount
    end

    def coupon
      return @order_coupon if defined?(@order_coupon)
      @order_coupon = BxBlockCoupons::Coupon.find_by_name(@name)
      return errors.add(:base, 'Invalid coupon') unless @order_coupon.present?
      @order_coupon
    end

    private

    def validate_min_order_amount
      @coupon = coupon
      return unless @coupon.present?
      errors.add(
        :min_order,
        "Add equal or greater #{@coupon.min_order - order_amount} service to apply this coupon "
      ) unless @coupon.min_order <= order_amount.to_f
    end
  end
end

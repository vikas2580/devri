module BxBlockCoupons
  class Coupon < ApplicationRecord
    self.table_name = :coupons

    include Wisper::Publisher

    has_many :coupon_services, class_name: "BxBlockCoupons::CouponService", dependent: :destroy
    accepts_nested_attributes_for :coupon_services

    validates_presence_of :name, :discount, :coupon_type, :min_order, :status, :max_discount
    validates_uniqueness_of :name
    validate :check_discount_percent

    enum coupon_type: {"up_to" => 0, "flat" => 1}
    enum status: { 'activated' => 1, 'expired' => 2 }


    private
    def check_discount_percent
      errors.add(:discount_percent, 'Invalid Discount Percent') if self.discount.to_i > 100
    end
  end
end

module BxBlockCoupons
  class CouponService < ApplicationRecord
    self.table_name = :coupon_services

    belongs_to :coupon, class_name: 'BxBlockCoupons::Coupon'
    belongs_to :sub_categories, class_name: 'BxBlockCategories::SubCategory'
  end
end


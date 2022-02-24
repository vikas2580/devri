module BxBlockPromoCodes
  class PromoCodeSerializer < BuilderBase::BaseSerializer
    attributes :name,
               :status,
               :discount_type,
               :discount,
               :description,
               :terms_n_condition,
               :redeem_limit,
               :max_discount_amount,
               :min_order_amount,
               :from,
               :to,
               :status

    attributes :malls do |object|
      object.mall_promo_codes.select(:mall_id)
    end

    attributes :restaurants do |object|
      object.restaurant_promo_codes.select(:id, :restaurant_id)
    end
  end
end

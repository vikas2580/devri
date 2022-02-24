module BxBlockPromoCodes
  class RestaurantPromoCode < ApplicationRecord
    self.table_name = :restaurant_promo_codes
    belongs_to :promo_code
  end
end

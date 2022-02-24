module BxBlockPromoCodes
  class MallPromoCode < ApplicationRecord
    self.table_name = :mall_promo_codes
    belongs_to :promo_code
  end
end

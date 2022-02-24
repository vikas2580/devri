module BxBlockPromoCodes
  class AccountPromoCode < ApplicationRecord
    self.table_name = :account_promo_codes
    belongs_to :promo_code
    belongs_to :account, class_name: 'AccountBlock::Account'
  end
end

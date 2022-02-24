module BxBlockCoupons
  class OrderComboOffer < ApplicationRecord
    self.table_name = :order_combo_offers
    belongs_to :combo_offer
    belongs_to :order, class_name: "BxBlockShoppingCart::Order"
  end
end

module BxBlockCoupons
  class ComboOffer < ApplicationRecord
    self.table_name = :combo_offers

    has_and_belongs_to_many :sub_categories,
                            class_name: 'BxBlockCategories::SubCategory',
                            dependent: :destroy, join_table: 'offer_services'
    has_one_attached :logo

    validates_presence_of :name, :discount_percentage, :offer_start_date, :offer_end_date
    validates_uniqueness_of :name


    before_save :calc_final_price

    private

    def calc_final_price
      original_price =  self.sub_categories.map{|a|a.price}.sum
      self.final_price = original_price - ((original_price * self.discount_percentage) / 100)
    end

    def suitable_service_provider
      BxBlockRolesPermissions::Role.find_by_name('Merchant').accounts self.sub_categories.ids
    end
  end
end

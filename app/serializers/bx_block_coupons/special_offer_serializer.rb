module BxBlockCoupons
  class SpecialOfferSerializer < BuilderBase::BaseSerializer
    attributes :id, :name, :sub_title, :active, :discount_percentage,
               :offer_end_date, :offer_start_date, :final_price

    attribute :logo_url do |object|
      object.logo.attached? ? object.logo.service_url : nil
    end

    attribute :services do |object|
      services_for object
    end

    class << self
      private

      def services_for special_offer
        BxBlockCategories::SubCategorySerializer.new(
          special_offer.sub_categories, params: {special_offer: special_offer}
        )
      end

      def offer_price_for price, discount_percent
        price - ((price * discount_percent) / 100)
      end
    end
  end
end

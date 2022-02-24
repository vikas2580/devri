module BxBlockCategories
  class BuildCategories
    class << self
      CATEGORIES_AND_SUB_CATEGORIES_HASH = {
        "Dresses" => [
          "Kurta Pajama"
        ],
        "Outerwear" => [],
        "Lingerie" => [],
        "Shoes" => [
          "Sneakers",
          "Loafers"
        ],
        "Accessories" => [],
        "Beauty" => []
      }


      def call(categories_and_sub_categories = CATEGORIES_AND_SUB_CATEGORIES_HASH)
        categories_and_sub_categories.each do |key,value|
          category = BxBlockCategories::Category.where(
            'lower(name) = ?', key.downcase
          ).first_or_create(:name=>key, :identifier=>category_identifier_hash[key])
          category.update(identifier: category_identifier_hash[key])
          value.each do |val|
            category.sub_categories.where(
              'lower(name) = ?', val.downcase
            ).first_or_create(:name=>val)
          end
        end
      end

      private

      def category_identifier_hash
        {
          "Dresses" => "dresses",
          "Outerwear" => "outerwear",
          "Lingerie" => "lingerie",
          "Shoes" => "shoes",
          "Accessories" => "accessories",
          "Beauty" => "beauty"
        }
      end

    end
  end
end

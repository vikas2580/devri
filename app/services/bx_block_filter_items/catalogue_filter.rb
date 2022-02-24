module BxBlockFilterItems
  class CatalogueFilter < ApplicationFilter

    private

    def query_string_for(attr_name, value)
      case attr_name
      when :price
        "price >= #{value[:from]} AND price <= #{value[:to]}"
      when :category_id, :sub_category_id, :brand_id
        ids = [*value].join(',')
        "#{attr_name} IN (#{ids})"
      else
        ""
      end
    end
  end
end

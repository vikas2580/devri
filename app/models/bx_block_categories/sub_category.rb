module BxBlockCategories
  class SubCategory < BxBlockCategories::ApplicationRecord
    self.table_name = :sub_categories

    belongs_to :category, class_name: 'BxBlockCategories::Category', foreign_key: 'category_id'
    belongs_to :parent, class_name: "BxBlockCategories::SubCategory", optional: true
    has_many :sub_categories, class_name: "BxBlockCategories::SubCategory",
             foreign_key: :parent_id, dependent: :destroy
    has_many :user_sub_categories, class_name: "BxBlockCategories::UserSubCategory",
             join_table: "user_sub_categoeries", dependent: :destroy
    has_many :accounts, class_name: "AccountBlock::Account", through: :user_sub_categories,
             join_table: "user_sub_categoeries"

    validates :name, uniqueness: true, presence: true
    validate :check_parent_category

    private

    def check_parent_category
      if category.blank? && parent.blank?
        errors.add(:base, "Please select categories or a parent.")
      end
    end

  end
end

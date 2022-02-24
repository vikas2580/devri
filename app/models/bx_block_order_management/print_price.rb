module BxBlockOrderManagement
  class PrintPrice < BxBlockOrderManagement::ApplicationRecord
    validates_uniqueness_of :page_size, scope: :colors

    scope :single_side, ->(page_size, colors) {
      where('LOWER(page_size) = ? AND LOWER(colors) =? ', page_size.downcase, colors.downcase)
    }
    scope :double_side, ->(page_size, colors) {
      where('LOWER(page_size) = ? AND LOWER(colors) =? ', page_size.downcase, colors.downcase)
    }
  end
end

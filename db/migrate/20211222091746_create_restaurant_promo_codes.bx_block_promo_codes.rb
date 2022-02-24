# This migration comes from bx_block_promo_codes (originally 20201211073929)
class CreateRestaurantPromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurant_promo_codes do |t|
      t.references :promo_code, null: false, foreign_key: true
      t.integer :restaurant_id, null: false

      t.timestamps
    end
  end
end

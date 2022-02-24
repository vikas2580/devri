# This migration comes from bx_block_promo_codes (originally 20201211082633)
class CreateMallPromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :mall_promo_codes do |t|
      t.references :promo_code, null: false, foreign_key: true
      t.integer :mall_id, null: false

      t.timestamps
    end
  end
end

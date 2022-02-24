# This migration comes from bx_block_coupons (originally 20201118111220)
class CreateComboOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :combo_offers do |t|
      t.string :name
      t.boolean :active, default: true
      t.integer :discount_percentage
      t.string :sub_title
      t.datetime :offer_end_date
      t.datetime :offer_start_date
      t.float :final_price
      t.timestamps
    end
  end
end

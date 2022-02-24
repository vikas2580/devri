# This migration comes from bx_block_coupons (originally 20201118130827)
class CreateOfferServices < ActiveRecord::Migration[6.0]
  def change
    create_table :offer_services do |t|
      t.bigint :combo_offer_id
      t.bigint :sub_category_id
    end
  end
end

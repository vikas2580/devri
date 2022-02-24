# This migration comes from bx_block_promo_codes (originally 20201209142222)
class CreateAccountPromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :account_promo_codes do |t|
      t.integer :redeem_count, default: 0, null: false
      t.references :promo_code, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

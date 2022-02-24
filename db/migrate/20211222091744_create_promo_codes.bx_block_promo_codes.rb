# This migration comes from bx_block_promo_codes (originally 20201209102549)
class CreatePromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :promo_codes do |t|
      t.string :name
      t.integer :discount_type
      t.integer :redeem_limit
      t.text :description
      t.text :terms_n_condition
      t.float :max_discount_amount
      t.float :min_order_amount
      t.datetime :from
      t.datetime :to
      t.integer :status
      t.float :discount

      t.timestamps
    end
  end
end

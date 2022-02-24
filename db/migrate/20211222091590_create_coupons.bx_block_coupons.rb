# This migration comes from bx_block_coupons (originally 20201002054714)
class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :discount
      t.integer :coupon_type
      t.float :min_order
      t.integer :status
      t.float :max_discount

      t.timestamps
    end
  end
end

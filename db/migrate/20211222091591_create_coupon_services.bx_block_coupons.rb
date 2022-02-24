# This migration comes from bx_block_coupons (originally 20201014103041)
class CreateCouponServices < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_services do |t|
      t.integer :sub_categories_id
      t.integer :coupon_id
    end
  end
end

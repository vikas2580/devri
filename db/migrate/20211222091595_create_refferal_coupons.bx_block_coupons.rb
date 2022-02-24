# This migration comes from bx_block_coupons (originally 20201126132011)
class CreateRefferalCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :refferal_coupons do |t|
      t.string :coupon
    end
  end
end

# This migration comes from bx_block_shopping_cart (originally 20200915082252)
class OrderServices < ActiveRecord::Migration[6.0]
  def change
    create_table :order_services do |t|
      t.references :shopping_cart_order, null: false, foreign_key: true
      #t.references :service, null: false, foreign_key: true
      t.bigint :sub_category_id
    end
  end
end

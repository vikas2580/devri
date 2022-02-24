# This migration comes from bx_block_shopping_cart (originally 20200831114430)
class CreateShoppingCartOrders < ActiveRecord::Migration[6.0]
  def change
    unless table_exists? :shopping_cart_orders
      create_table :shopping_cart_orders do |t|

        t.references :service_provider
        t.references :customer
        t.integer :address_id
        t.date :booking_date
        t.string :slot_start_time
        t.float :total_fees
        t.text :instructions
        t.string :service_total_time_minutes
        t.string :status
        t.float :discount
        t.integer :coupon_id
        t.boolean :is_coupon_applied
        t.integer :order_type
        t.boolean :notify_me
        t.boolean :job_status, :default => false
        t.string :ongoing_time
        t.string :finish_at

        t.timestamps
      end
    end
  end
end

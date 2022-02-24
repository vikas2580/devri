# This migration comes from bx_block_request_management (originally 20210106065547)
class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.integer :account_id
      t.integer :sender_id
      t.integer :status

      t.timestamps
    end
  end
end

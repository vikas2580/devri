# This migration comes from bx_block_followers (originally 20210125120510)
class AddCurrentUserToFollows < ActiveRecord::Migration[6.0]
  def change
    remove_column :follows, :current_user_id
    add_reference :follows, :current_user, foreign_key: {to_table: :accounts}
  end
end

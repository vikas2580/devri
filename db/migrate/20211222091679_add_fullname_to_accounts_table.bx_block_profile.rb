# This migration comes from bx_block_profile (originally 20210802072540)
class AddFullnameToAccountsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :full_name, :string, default: nil
  end
end

class AddHeightWeightToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :height, :float
    add_column :accounts, :weight, :float
    add_column :accounts, :height_type, :integer, default: 0
  end
end

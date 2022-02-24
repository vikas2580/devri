# This migration comes from bx_block_followers (originally 20200922123331)
class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.references :account, foreign_key: true, null: false
      t.integer :followable_id, null: false

      t.timestamps
    end
  end
end

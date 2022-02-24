# This migration comes from bx_block_profile (originally 20210804064914)
class CreateGlobalSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :global_settings do |t|
      t.string :notice_period
      t.timestamps
    end
  end
end

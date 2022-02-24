# This migration comes from bx_block_content_management (originally 20210407072202)
class CreateBxBlockVideosVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.integer :attached_item_id, index: true
      t.string :attached_item_type, index: true
      t.string :video

      t.timestamps
    end
  end
end

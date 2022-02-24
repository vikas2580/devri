# This migration comes from bx_block_reviews (originally 20210519133838)
class CreateBxBlockReviewsReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews_reviews do |t|
      t.string :title
      t.string :description
      t.integer :account_id
      t.integer :reviewer_id
      t.timestamps
    end
  end
end

module BxBlockReviews
  class Review < BxBlockReviews::ApplicationRecord
    self.table_name = :reviews_reviews

    belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :reviewer,  foreign_key: :reviewer_id, class_name: 'AccountBlock::Account'
    validates :account_id,
              uniqueness: { scope: [:reviewer_id, :anonymous], message: 'already reviewed' },
              if: :reviewer_id?

    validates_presence_of :title, :description
  end
end

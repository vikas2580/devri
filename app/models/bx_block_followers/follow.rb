module BxBlockFollowers
  class Follow < BxBlockFollowers::ApplicationRecord
    self.table_name = :follows
    validates :account_id, presence: true, allow_blank: false
    belongs_to :account, class_name: 'AccountBlock::Account', foreign_key: 'account_id'
    belongs_to :current_user, class_name: 'AccountBlock::Account', foreign_key: 'current_user_id'

    def self.policy_class
      FollowerPolicy
    end
  end
end

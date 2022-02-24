module BxBlockRequestManagement
  class Request < BxBlockRequestManagement::ApplicationRecord
    self.table_name = :requests

    belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :sender,  foreign_key: :sender_id, class_name: 'AccountBlock::Account'

    enum status: %i[Accepted Rejected], _prefix: :status

    scope :pending, -> { where(status: nil) }
    scope :accepted, -> { where(status: 'Accepted') }
    scope :rejected, -> { where(status: 'Rejected') }

    attr_accessor :mutual_friends

    private

    def self.mutual_friend(current_account, requests)
      requests.each do |req|
        if req.sender_id == current_account.id
          sender_friends = BxBlockRequestManagement::Request.where(
            "(sender_id=? or account_id=?) and status=?", req.account_id, req.account_id, 0
          ).pluck(:account_id, :sender_id)
          sender_friends = sender_friends.flatten - [req.account_id]
        else
          sender_friends = BxBlockRequestManagement::Request.where(
            "(sender_id=? or account_id=?) and status=?", req.sender_id, req.sender_id, 0
          ).pluck(:account_id, :sender_id)
          sender_friends = sender_friends.flatten - [req.sender_id]
        end
        receiver_friends = BxBlockRequestManagement::Request.where(
          "(sender_id=? or account_id=?) and status=?", current_account.id, current_account.id, 0
        ).pluck(:account_id, :sender_id)
        receiver_friends = receiver_friends.flatten - [current_account.id]

        mutual_friend_ids = sender_friends & receiver_friends
        friends = AccountBlock::Account.where(id: mutual_friend_ids)
        req.mutual_friends = friends || []
      end
    end
  end
end

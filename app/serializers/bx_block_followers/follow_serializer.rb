module BxBlockFollowers
  class FollowSerializer < BuilderBase::BaseSerializer
    include FastJsonapi::ObjectSerializer
    attributes *[
      :id,
        :current_user_id,
        :account_id,
        :created_at,
        :updated_at,
        :account
    ]
  end
end

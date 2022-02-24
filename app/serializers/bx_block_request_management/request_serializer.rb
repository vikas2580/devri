module BxBlockRequestManagement
  class RequestSerializer < BuilderBase::BaseSerializer
    attributes *[
      :sender_id,
      :account_id,
      :status,
      :created_at,
      :updated_at,
    ]

    attribute :full_name do |object, params|
      if object.sender_id == params[:current_user][:id]
        [object.account&.first_name, object.account&.last_name].join(" ")
      else
        [object.sender&.first_name, object.sender&.last_name].join(" ")
      end
    end

    attribute :mutual_friends_count do |object|
      object.mutual_friends&.count
    end
  end
end

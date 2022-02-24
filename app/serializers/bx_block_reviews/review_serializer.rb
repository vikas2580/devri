module BxBlockReviews
  class ReviewSerializer < BuilderBase::BaseSerializer
    attributes *[
      :id,
      :title,
      :description,
      :account_id,
      :created_at
    ]

    attribute :reviewer do |object|
      AccountBlock::AccountSerializer.new(object.reviewer).serializable_hash unless object.anonymous
    end

  end
end

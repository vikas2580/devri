module BxBlockReviews
  class ErrorSerializer < BuilderBase::BaseSerializer
    attribute :errors do |review|
      review.errors.as_json
    end
  end
end

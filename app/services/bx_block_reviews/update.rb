module BxBlockReviews
  class Update
    def initialize(review, review_attributes)
      @review = review
      @review_attributes = review_attributes
    end

    def execute
      @review.assign_attributes(@review_attributes)
      @review.save
      @review
    end
  end
end

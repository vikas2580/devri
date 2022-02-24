module BxBlockReviews
  class Create
    def initialize(current_user, review_attributes)
      @current_user = current_user
      @review_attributes = review_attributes
    end

    def execute
      @review_attributes['reviewer_id'] = @current_user.id
      review = Review.new(@review_attributes)
      review.save
      review
    end
  end
end

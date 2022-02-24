module BxBlockReviews
  class ReviewsController < ApplicationController
    before_action :load_account, only: [:index]
    before_action :load_review, only: [:update]

    def index
      reviews = BxBlockReviews::Review.find_by_account_id(@account.id)#@account.reviews
      render json: ReviewSerializer.new(reviews).serializable_hash,
             status: :ok
    end

    def create
      review_attributes = jsonapi_deserialize(params)
      service = BxBlockReviews::Create.new(current_user, review_attributes)
      result = service.execute
      if result.persisted?
        render json: ReviewSerializer.new(result).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(result).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def update
      return if @review.nil?

      review_attributes = jsonapi_deserialize(params)
      service = BxBlockReviews::Update.new(@review, review_attributes)
      result = service.execute
      if result.persisted?
        render json: ReviewSerializer.new(result).serializable_hash,
               status: :ok
      else
        render json: ErrorSerializer.new(result).serializable_hash,
               status: :unprocessable_entity
      end
    end

    private

    def load_account
      @account = AccountBlock::Account.find(params[:account_id])
      if @account.nil?
        render json: { message: 'Account does not exist' },
               status: :not_found
      end
    end

    def load_review
      @review = Review.find(params[:id])
      if @review.nil?
        render json: { message: 'Review does not exist' },
               status: :not_found
      end
    end

  end
end

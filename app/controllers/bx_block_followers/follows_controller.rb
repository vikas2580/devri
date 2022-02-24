module BxBlockFollowers
  class FollowsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :current_user
    before_action :validate_params, only: [:create]

    def index
      #get list of following
      @followers = Follow.where('current_user_id = ?', current_user.id)

      authorize Follow

      if @followers.present?
        render json: FollowSerializer.new(@followers, meta: {message: 'List of following users.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not following to any user.'}]}, status: :ok
      end
    end

    def show
      #Check if you follow this user
      @account = Follow.find_by(
        current_user_id: current_user.id,
        account_id: params[:id])
      if @account.present?
        authorize @account
        render json: FollowSerializer.new(@account,
                                          meta: {success: true, message: "Following this user."
                                          }).serializable_hash, status: :ok
      else
        render json: {errors: [
          {success: false, message: "Not following this user."},
        ]}, status: :ok
      end
    end

    def create
      follow_params = jsonapi_deserialize(params)
      followable_id = follow_params['account_id']
      follow = Follow.find_by(current_user_id: current_user.id, account_id: followable_id)
      return render json: {errors: [
        {message: 'You already follow.'},
      ]}, status: :unprocessable_entity if follow.present?
      #Check if user you want to follow does not exists
      @account = AccountBlock::Account.find_by(id: followable_id, activated: true)
      return render json: {errors: [
        {message: 'User does not exist.'},
      ]}, status: :unprocessable_entity unless @account.present?

      #If user try to follow self
      return render json: {errors: [
        {message: 'You cannot follow yourself.'},
      ]}, status: :unprocessable_entity if current_user.id == followable_id.to_i
      @follow = Follow.new(follow_params)
      authorize @follow
      @follow.current_user_id = current_user.id
      if @follow.save
        render json: FollowSerializer.new(@follow, meta: {
          message: "Successfully followed."}).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@follow.errors)},
               status: :unprocessable_entity
      end
    end

    def destroy
      @follow = Follow.find_by(id: params[:id])
      return render json: {errors: [
        {message: 'Not following this user.'},
      ]}, status: :unprocessable_entity if !@follow.present?
      if @follow.destroy
        render json: {message: "Successfully unfollowed."}, status: :ok
      else
        render json: {errors: format_activerecord_errors(@follow.errors)},
               status: :unprocessable_entity
      end
    end

    private

    def validate_params
      return render json: {errors: [
        {message: 'Parameter missing.'},
      ]}, status: :unprocessable_entity if params[:data][:attributes][:account_id].nil?
    end
  end
end

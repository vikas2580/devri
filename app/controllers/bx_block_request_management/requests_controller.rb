module BxBlockRequestManagement
  class RequestsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    before_action :load_account

    def index
      requests = BxBlockRequestManagement::Request.where(
        "(sender_id = ? or account_id = ?)",
        @current_account.id, @current_account.id
      )
      requests = requests.public_send(params[:filter_by_request]) if params[:filter_by_request]

      if params[:filter_by].present?
        if params[:filter_by] == 'newest_first'
          requests = requests.order('requests.created_at desc')
        elsif params[:filter_by] == 'oldest_first'
          requests = requests.order('requests.created_at asc')
        end
      end

      if params[:search_by_name].present?
        requests = requests.joins(:sender).where(
          "accounts.first_name ILIKE ? or accounts.last_name ILIKE ?",
          "%#{params[:search_by_name]}%", "%#{params[:search_by_name]}%"
        ).distinct
      end
      BxBlockRequestManagement::Request.mutual_friend(@current_account, requests)

      if requests.present?
        json_data = BxBlockRequestManagement::RequestSerializer.new(
          requests, params: {current_user: @current_account}
        ).serializable_hash
        json_data[:total_requests_count] = json_data[:data].count rescue 0
        render json: json_data
      else
        render json: [],
            status: :not_found
      end
    end

    def create
      return if @current_account.nil?
      begin
        request = BxBlockRequestManagement::Request.find_or_initialize_by(
          request_params.merge(sender_id: @current_account.id)
        )
        if request.save
          render json: {
            **BxBlockRequestManagement::RequestSerializer.new(
              request, params: {current_user: @current_account}
            ).serializable_hash,
            message: 'Request successfully send'
          }
        else
          render json: {errors: format_activerecord_errors(request.errors)},
              status: :unprocessable_entity
        end
      rescue Exception => request
        render json: {errors: request.message},
              status: :unprocessable_entity
      end
    end

    def show
      request = BxBlockRequestManagement::Request.where(
        "(sender_id = ? or account_id = ?)", @current_account.id, @current_account.id
      ).find_by(id: params[:id])

      return render json: {errors: [
          {Request: 'Not found'},
        ]}, status: :not_found if request.blank?

      render json: BxBlockRequestManagement::RequestSerializer.new(
        request, params: {current_user: @current_account}
      ).serializable_hash
    end

    def update
      return if @current_account.nil?
      begin
        request = BxBlockRequestManagement::Request.where(
          "(sender_id = ? or account_id = ?)", @current_account.id, @current_account.id
        ).find_by(id: params[:id])

        return render json: {errors: [
            {Request: 'Not found'},
          ]}, status: :not_found if request.blank?

        if request.update(request_params)
          render json: {
            **BxBlockRequestManagement::RequestSerializer.new(
              request, params: {current_user: @current_account}
            ).serializable_hash,
            message: 'Request successfully updated'
          }
        else
          render json: {errors: format_activerecord_errors(request.errors)},
              status: :unprocessable_entity
        end
      rescue Exception => request
        render json: {errors: request.message},
              status: :unprocessable_entity
      end
    end

    private

    def request_params
      params.require(:data).permit \
        :status, :account_id
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end

    def load_account
      @current_account = AccountBlock::Account.find_by(id: @token.id)

      if @current_account.nil?
        render json: {
            message: "Account with id #{@token.id} doesn't exist"
        }, status: :not_found
      end
    end
  end
end

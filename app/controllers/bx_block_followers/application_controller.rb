module BxBlockFollowers
  class ApplicationController < BuilderBase::ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    include Pundit

    before_action :validate_json_web_token

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def current_user
      begin
        @current_user = AccountBlock::Account.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {message: 'Please login again.'},
        ]}, status: :unprocessable_entity
      end
    end

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end
    def format_activerecord_errors(errors)
        result = []
        errors.each do |attribute, error|
          result << { attribute => error }
        end
        result
    end
  end
end

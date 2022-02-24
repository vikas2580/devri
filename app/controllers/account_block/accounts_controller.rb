module AccountBlock
  class AccountsController < ApplicationController
    skip_before_action :verify_authenticity_token
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:update, :search]
    before_action :set_current_user, only: [:update]
    
    def create
      case params[:data][:type] #### rescue invalid API format
=begin
      when 'sms_account'
        validate_json_web_token

        unless valid_token?
          return render json: {errors: [
            {token: 'Invalid Token'},
          ]}, status: :bad_request
        end

        begin
          @sms_otp = SmsOtp.find(@token[:id])
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: 'Confirmed Phone Number was not found'},
          ]}, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number
        @account = SmsAccount.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          render json: SmsAccountSerializer.new(@account, meta: {
            token: encode(@account.id)
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end
=end
      when 'email_account'
        account_params = jsonapi_deserialize(params)

        query_email = account_params['email'].downcase
        account = EmailAccount.where('LOWER(email) = ?', query_email).first

        email_validator = EmailValidation.new(account_params['email'])

        return render json: {errors: [
          {account: 'Email invalid'},
        ]}, status: :unprocessable_entity if !email_validator.valid?

        return render json: {errors: [
          {account: 'Account with this email id is already present. Please try to Login'},
        ]}, status: :unprocessable_entity if account

        password_validator = PasswordValidation.new(account_params['password'])

        return render json: {errors: [
          {account: 'Password invalid. It should be a minimum of 8 characters long, contain both uppercase and lowercase characters, at-least one digit, and one special character'},
        ]}, status: :unprocessable_entity if !password_validator.valid?


        @account = EmailAccount.new(jsonapi_deserialize(params))
        @account.platform = request.headers['platform'].downcase if request.headers.include?('platform')

        if @account.save
          # EmailAccount.create_stripe_customers(@account) #need to uncomment once the Payment Setup is done
          EmailValidationMailer
            .with(account: @account, host: request.base_url)
            .activation_email.deliver
          render json: EmailAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      when 'social_account'
        @account = SocialAccount.new(jsonapi_deserialize(params))
        @account.password = @account.email
        if @account.save
          render json: SocialAccountSerializer.new(@account, meta: {
            token: encode(@account.id),
          }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end

      else
        render json: {errors: [
          {account: 'Invalid Account Type'},
        ]}, status: :unprocessable_entity
      end
    end

    def update
      if @account.update(account_params)
        render json: AccountBlock::AccountSerializer.new(@account, meta: {
          message: 'Account Updated Successfully',
        }).serializable_hash, status: :ok
      else
        render json: { errors: format_activerecord_errors(@account.errors) },
               status: :unprocessable_entity
      end
    end

    def search
      @accounts = Account.where(activated: true)
                    .where('first_name ILIKE :search OR '\
                           'last_name ILIKE :search OR '\
                           'email ILIKE :search', search: "%#{search_params[:query]}%")
      if @accounts.present?
        render json: AccountSerializer.new(@accounts, meta: {message: 'List of users.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any user.'}]}, status: :ok
      end
    end

    private

    def encode(id)
      BuilderJsonWebToken.encode id
    end

    def search_params
      params.permit(:query)
    end

    def set_current_user
      @account = AccountBlock::Account.find(@token.id)
    end

    def account_params
      params.require(:account).permit(:first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :password_digest, :type, :user_name, :platform,:user_type, :last_visit_at, :suspend_until, :status, :stripe_subscription_id, :full_name,:gender, :date_of_birth, :age, :height_type, :height, :weight)
    end
  end
end

module BxBlockForgotPassword
  class OtpsController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
      # Check what type of account we are trying to recover
      json_params = jsonapi_deserialize(params)
      if json_params['email'].present?
        # Get account by email
        account = AccountBlock::EmailAccount
          .where(
            "LOWER(email) = ? AND activated = ?",
            json_params['email'].downcase,
            true
          ).first
        return render json: {
          errors: [{
            otp: 'Account not found',
          }],
        }, status: :not_found if account.nil?

        email_otp = AccountBlock::EmailOtp.new(jsonapi_deserialize(params))
        if email_otp.save
          email_otp.activated = true
          email_otp.save
          token = token_for(email_otp, account.id)
          send_email_for email_otp, token
          render json: serialized_email_otp(email_otp, account.id, token),
            status: :created
        else
          render json: {
            errors: [email_otp.errors],
          }, status: :unprocessable_entity
        end
      # elsif json_params['full_phone_number'].present?
      #   # Get account by phone number
      #   phone = Phonelib.parse(json_params['full_phone_number']).sanitized
      #   account = AccountBlock::SmsAccount.find_by(
      #       full_phone_number: phone,
      #       activated: true
      #   )
      #   return render json: {
      #     errors: [{
      #       otp: 'Account not found',
      #     }],
      #   }, status: :not_found if account.nil?

      #   sms_otp = AccountBlock::SmsOtp.new(jsonapi_deserialize(params))
      #   if sms_otp.save
      #     render json: serialized_sms_otp(sms_otp, account.id), status: :created
      #   else
      #     render json: {
      #       errors: [sms_otp.errors],
      #     }, status: :unprocessable_entity
      #   end
      else
        return render json: {
          errors: [{
            otp: 'Email required',
          }],
        }, status: :unprocessable_entity
      end
    end

    private

    def send_email_for(otp_record, token)
      EmailOtpMailer.with(otp: otp_record, token:token, host: request.base_url).otp_email.deliver
    end

    def send_email_password(otp_record, token)
      EmailOtpMailer.with(otp: otp_record, token:token, host: request.base_url).reset_email.deliver
    end

    def serialized_email_otp(email_otp, account_id, token)
      EmailOtpSerializer.new(
        email_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def serialized_sms_otp(sms_otp, account_id)
      token = token_for(sms_otp, account_id)
      SmsOtpSerializer.new(
        sms_otp,
        meta: { token: token }
      ).serializable_hash
    end

    def token_for(otp_record, account_id)
      BuilderJsonWebToken.encode(
        otp_record.id,
        5.minutes.from_now,
        type: otp_record.class,
        account_id: account_id
      )
    end
  end
end

module BxBlockProfile
  class ProfilesController < ApplicationController

    def create
      # @profile = current_user.create_profile(profile_params)
      @profile = BxBlockProfile::Profile.create(profile_params.merge({account_id: current_user.id}))

      if @profile.save
        render json: BxBlockProfile::ProfileSerializer.new(@profile
        ).serializable_hash, status: :created
      else
        render json: {
          errors: format_activerecord_errors(@profile.errors)
        }, status: :unprocessable_entity
      end
    end

    def show
      profile = BxBlockProfile::Profile.find(params[:id])
      if profile.present?
        render json: ProfileSerializer.new(profile).serializable_hash,status: :ok
      else
        render json: {
          errors: format_activerecord_errors(profile.errors)
        }, status: :unprocessable_entity
      end
    end

    def update
      status, result = UpdateAccountCommand.execute(@token.id, update_params)

      if status == :ok
        serializer = AccountBlock::AccountSerializer.new(result)
        render :json => serializer.serializable_hash,
          :status => :ok
      else
        render :json => {:errors => [{:profile => result.first}]},
          :status => status
      end
    end


    def destroy
      profile = BxBlockProfile::Profile.find(params[:id])
      if profile.present?
        profile.destroy
        render json:{ meta: { message: "Profile Removed"}}
      else
        render json:{meta: {message: "Record not found."}}
      end
    end

    def update_profile
      profile = BxBlockProfile::Profile.find_by(id: params[:id])
      profile.update(profile_params)
      if profile&.photo&.attached?
        render json: ProfileSerializer.new(profile, meta: {
            message: "Profile Updated Successfully"
          }).serializable_hash, status: :ok
      else
        render json: {
          errors: format_activerecord_errors(profile.errors)
        }, status: :unprocessable_entity
      end
    end

    def user_profiles
      profiles = current_user.profiles
      render json: ProfileSerializer.new(profiles, meta: {
        message: "Successfully Loaded"
      }).serializable_hash, status: :ok
    end

    private

    def current_user
      @account = AccountBlock::Account.find_by(id: @token.id)
    end

    def profile_params
      params.require(:profile).permit(:id, :country, :address, :city, :postal_code, :photo, :profile_role)
    end

    def update_params
      params.require(:data).permit \
        :first_name,
        :last_name,
        :current_password,
        :new_password,
        :new_email,
        :new_phone_number
    end
  end
end

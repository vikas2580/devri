ActiveAdmin.register AccountBlock::Account do
  menu label: "User"

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :device_id, :unique_auth_id, :password_digest, :type, :user_name, :platform, :user_type, :app_language_id, :last_visit_at, :is_blacklisted, :suspend_until, :status, :stripe_id, :stripe_subscription_id, :stripe_subscription_date, :role_id, :full_name, :gender, :date_of_birth, :age, :is_paid, :height, :weight, :height_type
  #
  # or
     scope :vendor
     scope :customer
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :device_id, :unique_auth_id, :password_digest, :type, :user_name, :platform, :user_type, :app_language_id, :last_visit_at, :is_blacklisted, :suspend_until, :status, :stripe_id, :stripe_subscription_id, :stripe_subscription_date, :role_id, :full_name, :gender, :date_of_birth, :age, :is_paid, :height, :weight, :height_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end

Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :account_block do
    resource :accounts
    namespace :accounts do
      resource :email_confirmations, only: :show
    end
  end

  namespace :bx_block_login do
    resource :logins, only: :create
  end

  namespace :bx_block_forgot_password do
    resource :otps, only: :create
    resource :otp_confirmations, only: :create
    resource :passwords, only: :create
  end

  namespace :bx_block_contact_us do
    resource :contacts
  end

  namespace :bx_block_categories do
    resources :categories
  end
end

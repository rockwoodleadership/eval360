Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  post 'salesforce_connector/new_participant'

  root 'pages#index'
  get 'logout' => 'pages#logout'
  
end

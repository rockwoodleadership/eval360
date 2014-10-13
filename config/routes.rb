Rails.application.routes.draw do

  resources :evaluations do
    get :edit
  end  

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  root 'pages#index'
  get 'logout' => 'pages#logout'

  post 'salesforce_connector/new_participant'
  
end

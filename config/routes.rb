Rails.application.routes.draw do

  resources :evaluations do
    get :edit
    post :update
  end  

  resources :participants do
    post :update
  end
  get ':id/invitations', to: 'participants#invitations', as: :invitations

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  root 'pages#index'
  get 'logout' => 'pages#logout'

  post 'salesforce_connector/new_participant'
  
end

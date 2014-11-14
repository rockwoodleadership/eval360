Rails.application.routes.draw do

  resources :evaluations do
    get :edit
    post :update
  end  

  resources :participants do
    post :update
  end

  resources :answers do
    post :update
  end

  get ':id/invitations', to: 'participants#invitations', as: :invitations
  post ':id/send_reminders', to: 'participants#send_reminders', as: :send_reminders

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  root to: redirect('/admin') 
  get 'logout' => 'pages#logout'
  get 'thank_you' => 'pages#thank_you'

  post 'salesforce_connector/new_participant'
  
end

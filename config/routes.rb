Rails.application.routes.draw do

  resources :evaluations do
    get :edit
    post :update
    get :peer_decline
  end  

  resources :participants, path: '' do
    post :update
    get :evaluation_report, on: :member, defaults: { format: 'pdf' }
    resource :report, only: :show
  end

  post '/trainings/:id/email_reports', to: 'trainings#email_reports'

  resources :answers do
    post :update
  end

  get ':id/invitations', to: 'participants#invitations', as: :invitations
  post ':id/send_reminders', to: 'participants#send_reminders', as: :send_reminders

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    resources :questionnaires do
      resources :sections do
        resources :questions
      end
    end

    resources :trainings do
      resources :participants do
        resources :evaluations
      end
    end
  end
  

  root to: redirect('http://rockwoodleadership.org') 
  get 'thank_you' => 'pages#thank_you'
  get 'peer_decline' => 'pages#peer_decline'

  post 'salesforce_connector/new_participant'
  post 'salesforce_connector/update_participant'
  post 'salesforce_connector/new_training'
  post 'salesforce_connector/update_training'
  
end

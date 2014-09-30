Rails.application.routes.draw do
  root 'pages#index'
  get 'logout' => 'pages#logout'
  
end

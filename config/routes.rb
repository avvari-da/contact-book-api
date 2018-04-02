Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  resources :users do
    resources :contacts
  end
end
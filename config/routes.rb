Rails.application.routes.draw do
  resources :users do
    resources :contacts
  end
end
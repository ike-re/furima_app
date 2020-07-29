Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'deliver_addresses', to: 'users/registrations#new_deliver_address'
    post 'deliver_addresses', to: 'users/registrations#create_deliver_address'
  end
  root 'items#index'
  resources :users
  # resources :deliver_addresses, only: [:create, :update, :edit]
  resources :creditcards, only: [:create, :update, :edit]
  resources :brands, only: [:create]
  resources :products do 
    resources :comments
  end
end
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'deliver_addresses', to: 'users/registrations#new_deliver_address'
    post 'deliver_addresses', to: 'users/registrations#create_deliver_address'
  end
  root 'users#show'
  get 'users/logout'
  get 'products/search_category_children'
  get 'products/search_category_grandchildren'
  resources :users
  resources :credit_cards
  resources :brands, only: [:create]
  resources :products do 
    resources :comments
  end
end
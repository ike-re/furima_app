Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'deliver_addresses', to: 'users/registrations#new_deliver_address'
    post 'deliver_addresses', to: 'users/registrations#create_deliver_address'
  end
  root 'products#index'
  resources :users do
    collection do
      get 'logout'
    end
  end
  resources :credit_cards
  resources :brands, only: [:create]
  resources :products do 
    member do
      get 'pay'
      get 'purchase'
    end
    collection do
      get 'paid'
      get 'search_category_children'
      get 'search_category_grandchildren'
    end
    resources :comments,only:[:create,:destroy]
  end
end
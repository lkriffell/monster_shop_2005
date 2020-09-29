Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit/password', to: 'users#edit_password'
  patch '/profile', to: 'users#update'
  patch '/profile/password', to: 'users#update_password'

  # resources :login, only: [:new, :create]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'



  namespace :admin do
    get '/dashboard', to: "dashboard#index"
    get '/users', to: "dashboard#show_users"
    get '/merchants', to: "dashboard#show_merchants"
    get 'merchant/:id/disable', to: "dashboard#disable_merchant"
    get 'merchant/:id/enable', to: "dashboard#enable_merchant"
    get "/merchants/:id", to: "merchants#show"
  end

  namespace :merchant do
    get '/dashboard', to: "dashboard#index"
    get '/items', to: "items#index"
    get '/orders/:id', to: "orders#show"
    get "/item_orders/:id/fulfill", to: "item_orders#update"
    # namespace :items do
      get '/items/:merchant_id', to: "items#index"
      patch '/items/:item_id', to: "items#update"
      delete '/items/:item_id', to: "items#destroy"
    # end
  end

  resources :merchants
  resources :items, only: [:index, :show, :edit, :update]

  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]

  patch "cart/:item_id", to: "cart#update"
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/profile/orders", to: "orders#index"
  patch '/profile/orders/:order_id/edit', to: 'orders#update'
  get '/profile/orders/:order_id', to: 'orders#show'

  resources :orders, only: [:new, :create, :show]
end

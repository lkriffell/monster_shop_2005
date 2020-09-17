Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit/password', to: 'users#edit_password'
  patch '/profile', to: 'users#update'


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
    get '/items/:merchant_id', to: "items#index"
    patch '/items/:item_id', to: "items#update"
    delete '/items/:item_id', to: "items#destroy"
  end

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  patch "cart/:item_id", to: "cart#update"
  # patch "/:item_id", action: :update, controller: "items"
  #above route is a  name space, namespace: cart do
  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/profile/orders", to: "orders#index"
  patch '/profile/orders/:order_id/edit', to: 'orders#update'
  get '/profile/orders/:order_id', to: 'orders#show'
  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
end

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  scope "(:locale)", locale: /en|ja/ do
    ActiveAdmin.routes(self)
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users, except: [:create, :new] do
    collection do
      resources :wishlists, only: [:index, :create] do
        collection do
          delete '/', to: 'wishlists#destroy', as: :delete_all
        end
      end
    end
  end
  get 'profile', to: 'users#show', as: :profile
  patch 'profile', to: 'users#update'
  get 'users_addresses', to: 'users#users_addresses'
  get 'transaction_history', to: 'payments#transaction_history'
  delete 'logout', to: 'users#logout'
  delete 'logout_from_other_devices', to: 'users#logout_from_other_devices'

  resource :session do
    post :login
    post :signup
    post :forgot_password
    post :resend_code
    post :verify_reset_code
    post :reset_password
    get :refresh
  end

  resource :carts, only: [] do
    get '/', to: 'carts#get_cart', as: :show
    post '/add_item', to: 'carts#add_item', as: :add_item
    patch '/update_item', to: 'carts#update_item', as: :update_item
    delete '/remove_item/', to: 'carts#remove_item', as: :remove_item
    delete '/clear', to: 'carts#clear', as: :clear
  end

  resources :orders, only: [:index, :show, :update] do
    collection do
      post :create_order
      post :create_order_from_cart
      post :check_order_payment_status
      post :apply_reward_points
      patch :update_delivery_address
      post :apply_coupon
    end
  end

  resources :products, param: :uuid do
    get :recommended_products, on: :member
    get :purchased_product, on: :collection
  end

  resources :comments
  resources :reviews
  resource :comment_reactions, only: [:create] do
    delete :remove_reaction
  end

  resources :categories, only: :index
  resources :coupons, only: :index
  resources :point_histories, only: :index

  patch '/comments/:id', to: 'reviews#update_comment', as: 'update_comment'
  delete '/comments/:id', to: 'reviews#delete_comment', as: 'delete_comment'
  post 'payments/sessions', to: 'payments#create_session'
  post '/webhooks/komoju', to: 'webhooks#komoju'
  get 'about', to: 'about#show'

  resources :delivery_addresses, only: [:index, :create] do
    collection do
      post :set_default
      post :update_delivery_address
      delete :remove_delivery_address
    end
  end

  resources :inquiry_forms, only: [:create]
  resources :newsletter_subscriptions, only: [:create]
  resources :messages, only: [:create, :index]

  namespace :admin do
    resources :chats do
      member do
        post :reply
      end
    end
  end

  resources :free_samples_requests, only: [:create]
  
  # Content Management API
  resources :contents, only: [:index, :show] do
    collection do
      get 'by_section/:section', to: 'contents#by_section', as: :by_section
    end
  end
  
  # Sidebar Content API
  get 'sidebar_contents/sidebar_content_show', to: 'sidebar_contents#sidebar_content_show'
end

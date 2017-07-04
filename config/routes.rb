require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions", invitations: "invitations"}
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  root 'homes#index'
  resources :homes
  resources :events
  namespace :superadmin do
    resources :event_types
    resources :events ,:only=>[:index ,:destroy]
    resources :clients do
      delete :remove_brand
      get :impersonate
      resources :users do
        get :resend_invitation
      end
    end
    resources :promo_reps do
      get :resend
    end
    resources :groups
    resources :events
    resources :brands
  end
  namespace :admin do
    get '/login_as_master' => 'admin_application#login_as_master'
    resources :dashboard do
      collection do
        get "images"
      end
    end
    resources :promo_reps do
      get :resend
    end
    resources :events do
      resources :user_events do
        delete :delete_image
      end
    end
    resources :groups
    resources :clients do
      collection do
        get :reps_and_groups
      end
    end
  end
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :contacts
      resources :events do
        collection do
          get :active
          get :expired
        end
      end
    end
  end
end

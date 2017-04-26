Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  root 'homes#index'

  resources :homes
  resources :events


  namespace :superadmin do
    resources :event_types
    resources :clients do
      get :impersonate
      resources :users
    end
    resources :events
    resources :brands
  end


  namespace :admin do
    get '/login_as_master' => 'admin_application#login_as_master'
    resources :promo_reps
    resources :events
    resources :groups
    resources :clients do
      collection do
        get :reps_and_groups
      end
    end
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}
  root 'homes#index'

  resources :homes
  resources :events


  namespace :superadmin do
    resources :event_types
    resources :clients do
      resources :users
    end
    resources :events
    resources :brands
  end


  namespace :admin do
    resources :promo_reps
    resources :events
    resources :groups
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :events
    end
  end
end

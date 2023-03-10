Rails.application.routes.draw do
  root 'sessions#new'
  resources :tasks do
    collection do
      post :confirm
    end
  end
  resources :sessions, only: %i(new create destroy)
  resources :users, only: %i(new create show edit update destroy)
  namespace :administrator do
    resources :users
  end
end

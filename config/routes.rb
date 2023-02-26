Rails.application.routes.draw do
  root 'sessions#new'
  resources :tasks
  resources :sessions, only: %i(new create destroy)
  resources :users, only: %i(new create show edit update destroy)
end

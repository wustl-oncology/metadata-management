Rails.application.routes.draw do
  resources :projects, except: [:destroy] do
    resources :uploads, only: %i[new create show]
    resources :samples, only: [:index]
    resources :sequencing_products, only: [:index]
    resources :pipeline_outputs, only: %i[index new create]
  end

  resources :samples, only: %i[index show edit update]
  resources :sequencing_products, only: %i[index show edit update]
  resources :pipeline_outputs, only: %i[index show edit update]
  post '/pipeline_outputs' => 'pipeline_outputs_api#create'

  post '/search' => 'search#index'

  resources :notes, only: [:index]
  resources :users, only: [:show]
  post '/refresh_token' => 'users#refresh_token'

  get '/notes/:subject/:id' => 'notes#preview', as: :preview_note

  get '/sign_in' => 'static#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/sign_out' => 'sessions#destroy', as: :signout

  mount SolidErrors::Engine, at: '/errors', constraints: UserIsAdminConstraint.new
  mount MissionControl::Jobs::Engine, at: '/jobs', constraints: UserIsAdminConstraint.new

  root to: 'static#index'
end

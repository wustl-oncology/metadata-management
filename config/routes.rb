Rails.application.routes.draw do
  root "dashboard#show"

  resources :projects, except: [:destroy] do
    resources :uploads, only: [:new, :create, :show]
    resources :samples, only: [:index]
    resources :sequencing_products, only: [:index]
    resources :pipeline_outputs, only: [:index]
  end

  resources :samples, only: [:index]
  resources :sequencing_products, only: [:index]

  resources :notes, only: [:index]

  get '/notes/:subject/:id' => 'notes#preview', as: :preview_note
end

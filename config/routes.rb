Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  root "dashboard#show"

  resources :projects, except: [:destroy]

  get '/notes/:subject/:id' => 'notes#preview', as: :preview_note
end

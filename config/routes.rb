Rails.application.routes.draw do
  root to: "application#welcome", as: 'welcome'

  get "about" => "application#about"

  resources :repositories

  #We only accept html request to block request like /users/robots.txt
  resources :users, constraints: {format: /(html)/}, only: [:index, :search, :show] do
    get 'search', on: :collection
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  namespace :api do
    namespace :v0 do
      resources :users, constraints: { format: /(json)/ }, only: [:index] do
        get 'search', on: :collection
      end
      resources :languages, only: [:index]
    end
  end
end

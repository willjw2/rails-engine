Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/items/find_all', to: 'api/v1/items/search#index'
  get '/api/v1/merchants/find', to: 'api/v1/merchants/search#show'

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resource :merchant, only: [:show]
      end
    end
  end
end

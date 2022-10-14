Rails.application.routes.draw do
  get 'databases/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :databases do
    member do
      post 'sync_schemas'
    end
  end
end

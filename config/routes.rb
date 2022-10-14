Rails.application.routes.draw do
  root 'databases#index'

  resources :databases do
    resources :database_schemas do
      member do
        post :sync_tables
      end
    end

    member do
      post 'sync_schemas'
    end
  end
end

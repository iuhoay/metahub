Rails.application.routes.draw do
  root 'databases#index'

  resources :databases do
    resources :database_schemas do
      resources :database_tables do
        member do
          post :sync_fields
        end
      end

      member do
        post :sync_tables
      end
    end

    member do
      post 'sync_schemas'
    end
  end
end

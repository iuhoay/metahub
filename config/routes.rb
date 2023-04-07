Rails.application.routes.draw do
  root "database_schemas#index"

  resources :databases do
    resources :database_schemas do
      resources :database_tables, only: [:show] do
        resources :table_fields
        member do
          post :sync_fields
        end
      end

      member do
        post :sync_tables
        post :pin
        delete :unpin
        post :export_hive
      end
    end

    member do
      post "sync_schemas"
    end
  end

  mount GoodJob::Engine => "/good_job" if Rails.env.development?
end

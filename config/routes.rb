Rails.application.routes.draw do
  devise_for :users

  root "database_schemas#index"

  resources :databases do
    resources :database_schemas do
      resources :database_tables, only: [:show, :edit, :update] do
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

  resource :up, only: [:show], controller: :up

  mount GoodJob::Engine => "/good_job" if Rails.env.development?
end

# config/routes.rb
Rails.application.routes.draw do
  # Mounting Rswag for API documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :products do
        resource :inventory, only: [:show, :update]
      end
      
      resources :categories
      
      post 'inventories/batch', to: 'inventories#batch_update'
    end
  end
  
  # Health check endpoint
  get '/health', to: proc { [200, {}, ['Product Service is healthy']] }
  
  # Root path for basic info
  root to: proc { [200, {}, ['DataBridge Product Service']] }

end
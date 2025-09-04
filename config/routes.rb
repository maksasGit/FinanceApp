require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  scope "api/v1" do
    get "up" => "rails/health#show", as: :rails_health_check
    post "/auth/login", to: "auth#login"

    resources :users, only: [ :index, :show, :create, :update, :destroy ]
    resources :currencies, only: [ :index, :show, :create, :update, :destroy ]
    resources :categories, only: [ :index, :show, :create, :update, :destroy ]
    resources :transactions, only: [ :index, :show, :create, :update, :destroy ]
    resources :scheduled_transactions, only: [ :index, :show, :create, :update, :destroy ]
  end

  mount Sidekiq::Web => "/sidekiq"
end

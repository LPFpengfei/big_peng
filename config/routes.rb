Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Admin routes
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :admins

    root to: "admins#index"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      delete "auth/logout", to: "auth#logout"

      # Books routes
      resources :books, only: [ :index, :show, :create, :update, :destroy ]

      # Bookshelves routes
      resources :bookshelves, only: [ :index, :create, :destroy ]

      # Bookmarks routes
      resources :bookmarks, only: [ :index, :create, :update, :destroy ]

      # Reading Progresses routes
      get "reading_progresses/:book_id", to: "reading_progresses#show"
      put "reading_progresses/:book_id", to: "reading_progresses#update"
    end
  end
end

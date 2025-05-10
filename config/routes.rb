Rails.application.routes.draw do
  get 'decision_tree/index', to: 'decision_tree#index'
  post 'decision_tree/next_question', to: 'decision_tree#next_question', as: :decision_tree
  get 'decision_tree/:file_name', to: 'decision_tree#show', as: 'decision_tree_show'

  get "posts/index"
  get 'posts/:file_name', to: 'posts#show', as: 'post'

  get "pages/home"
  get "pages/about"

  resources :fraud_prompts, only: [:index, :show, :new, :create]

  # devise_for :users
  # get '/users', to: redirect('/users/sign_in')
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [:index, :show, :edit, :update]

=begin
  devise_for :users, controllers: {
	registrations: 'users/registrations'
  }
=end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#about"
end

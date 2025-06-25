Rails.application.routes.draw do
  get "admin/dashboard", to: 'admin#dashboard', as: :admin_dashboard
  get 'decision_tree/index', to: 'decision_tree#index'
  post 'decision_tree/next_question', to: 'decision_tree#next_question', as: :decision_tree
  get 'decision_tree/:file_name', to: 'decision_tree#show', as: 'decision_tree_show'
  # get '/users/sign_up' => redirect('/users/sign_up/')

  get "posts/index"
  get 'posts/new_upload',      to: 'posts#new_upload'
  post 'posts/upload',         to: 'posts#upload'
  post 'posts/:file_name/send_notification_email', to: 'posts#send_notification_email', as: 'send_notification_email'

  # get 'posts/:file_name/edit', to: 'posts#edit', as: 'edit_post'
  # patch 'posts/:file_name',    to: 'posts#update', as: 'update_post'
  get 'posts/edit/:file_name', to: 'posts#edit', as: 'edit_post'
  patch 'posts/update/:file_name',    to: 'posts#update', as: 'update_post'

  # Catch all route must be last
  get 'posts/:file_name',      to: 'posts#show', as: 'post'

  get "pages/home"
  get "pages/about"

  resources :fraud_prompts, only: [:index, :show, :new, :create]

  # devise_for :users
  # get '/users', to: redirect('/users/sign_in')
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: [:index, :show, :edit, :update]

  post 'decision_tree/:file_name/decision_tree_send_notification_email', to: 'decision_tree#decision_tree_send_notification_email', as: 'decision_tree_send_notification_email'

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

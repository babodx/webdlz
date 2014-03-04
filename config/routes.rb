Dns::Application.routes.draw do
  get "admin/edit"

  get "admin/create"

  get "admin/update"

  get "admin/destroy"

  get "admin/show"


  resources :admin do
    resources :admin_records do
      get 'disable'
      get 'activate'
      get 'destroy_disabled'
    end
  end

  resources :names do
    resources :records do
      get 'disable'
      get 'activate'
      get 'destroy_disabled'
    end
  end
  #match '/records/new/:zoneid' => 'records#new'
  match '/auth/webmoney/callback', to: 'sessions#create'
  post "auth/webmoney/callback"
  get "sessions/new"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get "sign_in", :to => redirect('/users/auth/webmoney'), :as => :new_user_session
    get "login", :to => redirect('/users/auth/webmoney'), :as => :new_session
    get "sign_out", :to => "devise/sessions#destroy"
  end
  root :to => 'names#index'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end

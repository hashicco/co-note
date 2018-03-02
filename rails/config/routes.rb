Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :notes
  resources :groupss

  resources :users, :except => [:index]
  resources :password_auths, :only => [:new, :create, :destroy]
  get 'login' => 'password_auths#new', :as => :login
  post 'logout' => 'password_auths#destroy', :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  root :to => 'notes#index'
end

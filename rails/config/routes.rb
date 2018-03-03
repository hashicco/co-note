Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :notes do
    member do
      get   'disclosures'       => "notes#show_disclosures"
      get   'disclosures/edit'  => "notes#edit_disclosures"
      patch 'disclosures'       => "notes#update_disclosures"
    end
  end
  resources :groups

  resources :users, :except => [:index, :show]
  resources :password_auths, :only => [:new, :create, :destroy]
  get 'login' => 'password_auths#new', :as => :login
  post 'logout' => 'password_auths#destroy', :as => :logout

  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  root :to => 'notes#index'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "addresses#new"
  resources :addresses, only: [:new, :create]
  resources :manifest, only: [:index]
end

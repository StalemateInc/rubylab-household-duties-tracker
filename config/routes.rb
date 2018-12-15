Rails.application.routes.draw do
  devise_for :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'landing#index'
  get '/index', to: 'landing#index'
  resources :groups do
    resources :tasks
  end
end

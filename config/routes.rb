Rails.application.routes.draw do
  devise_for :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'landing#index'
  get '/index', to: 'landing#index'
  resources :groups do
    resources :tasks do
      get '/estimate', to: 'estimation#estimate'
      get '/estimate/view', to: 'estimation#view'
      patch '/estimate', to: 'estimation#send_estimate'
      post '/estimate/confirm', to: 'estimation#confirm'
      post '/estimate/reject', to: 'estimation#reject'
    end
  end
end

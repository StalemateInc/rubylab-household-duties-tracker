Rails.application.routes.draw do
  devise_for :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'landing#index'
  get '/index', to: 'landing#index'
  resources :groups do
    get '/member/new', to: 'memberships#new'
    post '/member/new', to: 'memberships#create'
    resources :tasks do
      resources :comments, only: %i[create edit update destroy] do
        member do
          get :reply
        end
      end
      get '/estimate', to: 'estimation#estimate'
      patch '/estimate', to: 'estimation#send_estimate'
      post '/estimate/confirm', to: 'estimation#confirm'
      post '/estimate/reject', to: 'estimation#reject'
    end
  end
end

Rails.application.routes.draw do
  devise_for :user
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
      get '/rate', to: 'tasks#prompt_rate'
      post '/rate', to: 'tasks#rate'
      get '/estimate', to: 'estimation#estimate'
      post '/estimate', to: 'estimation#send_estimate'
      post '/estimate/accept', to: 'estimation#accept'
      post '/estimate/reject', to: 'estimation#reject'
      get '/estimate/pause', to: 'estimation#prompt_pause'
      post '/estimate/pause', to: 'estimation#pause'
      post '/estimate/resume', to: 'estimation#resume'
      post '/estimate/stop', to: 'estimation#stop'
    end
  end
end

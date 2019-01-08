Rails.application.routes.draw do

  if Rails.env.development?
    require 'sidekiq/web'
    require 'sidekiq/cron/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'landing#index'
  devise_for :user, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get '/user', to: 'users/registrations#show'
  end
  get '/index', to: 'landing#index'
  get '/search', to: 'search#index'
  match 'lang/:locale', to: 'index#change_locale', as: :change_locale, via: [:get]
  resource :categories, only: %i[show]
  resource :tags, only: %i[show]
  resources :groups do
    get '/member/new', to: 'memberships#new'
    post '/member/new', to: 'memberships#create'
    delete '/member', to: 'memberships#destroy'
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

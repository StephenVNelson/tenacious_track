Rails.application.routes.draw do

  get 'workouts/index'

  get 'workouts/show'

  get 'password_resets/new'

  get 'password_resets/edit'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'sessions#new'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :exercises
  resources :elements
  resources :element_categories,  only: [:index, :create, :edit, :update, :destroy]
  resources :workouts, only: [:index, :show]
  get 'workouts/new/:client', to: 'workouts#new', as: :new_workout

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :elements do
    collection {post :import}
  end

end

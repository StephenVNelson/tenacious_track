Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'sessions#new'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :exercises do
    get 'autocomplete', on: :collection
  end
  resources :elements
  resources :element_categories,  only: [:index, :create, :edit, :update, :destroy]
  resources :workouts, only: [:index, :show, :create]
  get 'workouts/new/:client', to: 'workouts#new', as: :new_workout
  get 'workouts/select_client/new', to: 'workouts#select_client', as: :select_workout_client
  get 'workouts/apply-template/:workout', to: 'workouts#select_template', as: :select_workout_template
  resources :clients
  resources :executions, only: [:create, :edit, :destroy]
  get 'workouts/:id/executions/new', to: 'executions#new'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :elements do
    collection {post :import}
  end

end

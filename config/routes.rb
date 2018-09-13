Rails.application.routes.draw do
  get 'elements/index'

  get 'elements/new'

  get 'elements/edit'

  get 'password_resets/new'

  get 'password_resets/edit'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'sessions#new'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  resources :elements do
    collection {post :import}
  end

end

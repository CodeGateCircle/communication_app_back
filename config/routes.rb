Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#destroy', as: 'log_out'
  # get 'log_out', to: 'sessions#destroy', as: 'log_out'
  get '/go', to: 'auth#google_oauth2'

  resources :sessions, only: %i[create destroy]
end

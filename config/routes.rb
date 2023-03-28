Rails.application.routes.draw do
  post '/authentications', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'
  get '/auth/:provider/callback', to: 'omniauth_callbacks#google_oauth2'
end

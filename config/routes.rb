Rails.application.routes.draw do
  # google 認証
  get 'auth/:provider/callback', to: 'omniauth_callbacks#google_oauth2'
  mount_devise_token_auth_for 'User', at: 'auth'

  # プロフィール取得
  get 'profile', to: 'profile#index'

  # workspace作成
  post '/workspaces', to: 'workspaces#create'

end

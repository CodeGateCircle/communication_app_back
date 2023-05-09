Rails.application.routes.draw do
  # google 認証
  get 'auth/:provider/callback', to: 'omniauth_callbacks#google_oauth2'
  mount_devise_token_auth_for 'User', at: 'auth'

  # プロフィール取得
  get 'profile', to: 'profile#index'

  # workspace作成
  post '/workspaces', to: 'workspaces#create'
  # workspace削除
  post '/workspaces/:workspace_id/delete', to: 'workspaces#delete'
  # workspace更新
  put '/workspaces/:workspace_id', to: 'workspaces#update'

  # room作成
  post '/rooms', to: 'rooms#create'
  # room一覧取得
  get '/rooms', to: 'rooms#index'
  # room削除
  post 'rooms/:room_id/delete', to: 'rooms#delete'
end

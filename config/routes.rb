Rails.application.routes.draw do
  # google 認証
  get 'auth/:provider/callback', to: 'omniauth_callbacks#google_oauth2'
  mount_devise_token_auth_for 'User', at: 'auth'

  # プロフィール取得
  get '/profile', to: 'profile#index'
  # プロフィール更新
  put '/profile', to: 'profile#edit'
  # プロフィール削除
  post '/profile/delete', to: 'profile#delete'

  get '/workspaces', to: 'workspaces#index'
  # workspace作成
  post '/workspaces', to: 'workspaces#create'
  # workspace削除
  post '/workspaces/:workspace_id/delete', to: 'workspaces#delete'
  # workspace更新
  put '/workspaces/:workspace_id', to: 'workspaces#update'
  # workspace招待
  post "/workspaces/invite", to: 'workspaces#invite'

  # room作成
  post '/rooms', to: 'rooms#create'
  # room一覧取得
  get '/rooms', to: 'rooms#index'
  # room更新
  put '/rooms/:room_id', to: 'rooms#update'
  # room削除
  post '/rooms/:room_id/delete', to: 'rooms#delete'
  # roomの招待
  post '/rooms/:room_id/invite', to: 'rooms#invite'
  # roomのユーザー削除
  post '/rooms/:room_id/remove', to: 'rooms#remove'

  # category作成
  post '/categories', to: 'category#create'
  # category取得
  get '/categories', to: 'category#index'
  # category更新
  put '/categories/:category_id', to: 'category#update'
  # category削除
  post '/categories/:category_id/delete', to: 'category#delete'

  # message取得
  get '/messages', to: 'messages#index'

  # reaction作成
  post '/reactions', to: 'reaction#create'
  # reaction取得
  get '/reactions', to: 'reaction#index'
  # reaction削除
  post 'reactions/delete', to: 'reaction#delete'
end

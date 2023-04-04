class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def google_oauth2
    # リクエストから認証情報を取得
    @resource = User.from_omniauth(request.env['omniauth.auth'])

    # トークンを発行してレスポンスを返す
    @token = @resource.create_token
    @resource.save

    render json: {
      data: {
        auth_token: @token.token,
        client: @token.client,
        uid: @resource.uid
      },
      status: :ok
    }
  end
end

class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def google_oauth2
    # リクエストから認証情報を取得
    @resource = User.from_omniauth(request.env['omniauth.auth'])

    # トークンを発行してレスポンスを返す
    @token = @resource.create_token
    @resource.save

    logger.debug @token.token

    redirect_to "http://localhost:5173/auth/callback?access_token=#{@token.token}&uid=#{@resource.uid}&client=#{@token.client}"
  end
end

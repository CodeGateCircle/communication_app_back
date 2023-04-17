# frozen_string_literal: true

def get_auth_token(user)
  post '/auth/sign_in/',
       params: { email: user.email, password: user.password },
       as: :json

  response.headers.slice('client', 'access-token', 'uid')
end

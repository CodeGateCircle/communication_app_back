module Api
  module V1
    class AuthenticationsController < ApplicationController
      def create
        user = User.from_omniauth(request.env['omniauth.auth'])
        auth_token = user.generate_auth_token
        render json: { auth_token: auth_token }
      end
    
      def failure
        render json: { errors: ['Authentication failed'] }, status: :unauthorized
      end
    end
  end
end


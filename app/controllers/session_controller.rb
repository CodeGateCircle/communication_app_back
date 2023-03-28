class SessionsController < ApplicationController
  skip_before_action :check_logged_in, only: :create

  def create
    logger.debug('----1---')
    logger.debug(auth_hash)
    if (user = User.find_or_create_from_auth_hash(auth_hash))
      log_in user
    end
    logger.debug('----2---')
    render json: { errors: ['Authentication failed'] }, status: :unauthorized
  end
  
  def destroy
    log_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end


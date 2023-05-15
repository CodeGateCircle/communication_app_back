# profile
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user , serializer: UserSerializer
  end
end

# profile
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
      data: current_user
    }
  end
end

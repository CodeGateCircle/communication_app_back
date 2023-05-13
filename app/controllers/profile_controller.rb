# profile
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: {
      data: current_user
    }
  end

  def edit
    params = update_params
    current_user.name = params[:name]
    current_user.image = params[:image]
  end

  private

  def update_params
    params.permit(:name, :image)
  end
end

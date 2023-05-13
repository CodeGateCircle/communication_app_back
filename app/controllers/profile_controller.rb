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
    user = User.find(current_user.id)
    user.update({
                  name: params[:name],
                  image: params[:image]
                })

    render json: {
      data: current_user
    }
  end

  private

  def update_params
    params.permit(:name, :image)
  end
end

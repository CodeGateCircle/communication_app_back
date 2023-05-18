# profile
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user, serializer: UserSerializer
  end

  def edit
    params = update_params
    user = User.find(current_user.id)
    user.update({
                  name: params[:name],
                  image: params[:image]
                })

    render json: {
      data: user
    }
  end

  def delete
    if current_user.is_deleted
      render status: 400, json: { status: "failure" }
    else
      current_user.update({ is_deleted: true })

      render status: 200, json: { status: "success" }
    end
  end

  private

  def update_params
    params.permit(:name, :image)
  end
end

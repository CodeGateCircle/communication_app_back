# profile
require 'net/http'
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user
  end

  def edit
    user = if params[:image].present?
             update_with_image
           else
             update_without_image
           end
    render json: user
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

  def update_with_image
    params = update_params
    user = User.find(current_user.id)

    path = preserve_image(params[:image], user.user_image)

    user.update({
                  name: params[:name],
                  image: path
                })
    user
  end

  def update_without_image
    params = update_params
    user = User.find(current_user.id)
    user.update({
                  name: params[:name]
                })
    user
  end
end

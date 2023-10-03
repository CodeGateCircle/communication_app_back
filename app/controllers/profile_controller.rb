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

    if String(params[:image]).start_with?('http')
      user = update_with_url
    else
      user.user_image.attach(params[:image])
    end

    path = Rails.application.routes.url_helpers.rails_blob_path(user.user_image, only_path: true)
    user.update({
                  name: params[:name],
                  image: path
                })
    user
  end

  def update_with_url
    user = User.find(current_user.id)

    image_url = String(params[:image])

    url = URI.parse(image_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https') # HTTPSの場合はSSLを使用

    response = http.get(url.request_uri)

    io = StringIO.new(response.body)
    user.user_image.attach(io:, filename: "#{current_user.name}_image")
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

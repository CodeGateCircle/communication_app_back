# profile
require 'net/http'
class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    user = if current_user.workspaces.present?
             current_user
           else
             initial_action
           end
    render json: user
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

  def initial_action
    workspace = Workspace.create!({
                                    name: "#{current_user.name}'s workspace'",
                                    description: "this is default workspace"
                                  })
    workspace_user = WorkspaceUser.new({
                                         workspace_id: workspace[:id],
                                         user_id: current_user.id
                                       })
    workspace_user.save!
    category = Category.create!({
                                  name: "category",
                                  workspace_id: workspace.id
                                })
    room = Room.create!({
                          name: "default room",
                          description: "default made room",
                          category_id: category.id,
                          workspace_id: workspace.id
                        })
    room_user = RoomUser.new({
                               user_id: current_user.id,
                               room_id: room.id
                             })
    room_user.save!
    workspace_user
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

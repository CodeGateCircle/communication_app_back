# workspace
class WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def index
    workspaces = current_user.workspaces.order(id: :asc)
    render json: workspaces, each_serializer: WorkspaceSerializer
  end

  def create
    params = create_params

    Workspace.transaction do
      workspace = Workspace.create!({
                                      name: params[:name],
                                      description: params[:description],
                                      icon_image_url: params[:icon_image_url],
                                      cover_image_url: params[:cover_image_url]
                                    })

      workspace_user = WorkspaceUser.new({
                                           workspace_id: workspace[:id],
                                           user_id: current_user.id
                                         })
      workspace_user.save!

      render status: 200, json: workspace
    end
  end

  def update
    params = create_params

    Workspace.transaction do
      workspace = Workspace.find(params[:workspace_id])
      workspace.update!({
                          name: params[:name],
                          description: params[:description],
                          icon_image_url: params[:icon_image_url],
                          cover_image_url: params[:cover_image_url]
                        })

      render status: 200, json: workspace
    end
  end

  def delete
    workspace = Workspace.find(params[:workspace_id])
    workspace.destroy!

    render status: 200, json: { success: true }
  end

  def invite
    # # もし、過去に作ったURLがあるとき
    # URLをreturn
    url = Invite.find_by()

    # # なかったとき
    # URLを生成する
    # return
  end

  def confirm

  end

  private

  # strong parameter
  def create_params
    params.permit(:workspace_id, :name, :description, :icon_image_url, :cover_image_url)
  end
end

# workspace
class WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def index
    workspaces = current_user.workspaces
    render json: { data: { workspaces: workspaces.map(&:format_res) } }
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

      render status: 200, json: workspace, serializer: WorkspaceSerializer
    end
  end

  def update
    params = create_params_id

    Workspace.transaction do
      workspace = Workspace.find(params[:workspace_id])
      workspace.update!({
                          name: params[:name],
                          description: params[:description],
                          icon_image_url: params[:icon_image_url],
                          cover_image_url: params[:cover_image_url]
                        })

      render status: 200, json: workspace, serializer: WorkspaceSerializer
    end
  end

  def delete
    workspace = Workspace.find(params[:workspace_id])
    workspace.destroy!

    render status: 200, json: { success: true }
  end

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :icon_image_url, :cover_image_url)
  end

  def create_params_id
    params.permit(:workspace_id, :name, :description, :icon_image_url, :cover_image_url)
  end
end

# workspace
class WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def create
    params = create_params

    workspace = Workspace.create!({
                                    name: params[:name],
                                    description: params[:description],
                                    icon_image_url: params[:iconImageUrl],
                                    cover_image_url: params[:coverImageUrl]
                                  })

    workspace_user = WorkspaceUser.new({
                                         workspace_id: workspace[:id],
                                         user_id: current_user.id
                                       })
    workspace_user.save
    # TODO: 保存が成功しなかったときの対応など

    render status: 200, json: { data: { workspace: workspace.format_res } }
  end

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :iconImageUrl, :coverImageUrl)
  end
  
  # workspace update (edit => update)
  def update
    workspace = Workspace.find_by(id: params[:workspace_id])
    workspace.name = params[:name]
    workspace.description = params[:description]
    workspace.icon_image_url = params[:iconImageUrl]
    workspace.cover_image_url = params[:coverImageUrl]

    workspace.save
    render json: {
      data: {
        workspace: {
          name: workspace.name,
          description: workspace.description,
          iconImageUrl: workspace.icon_image_url,
          coverImageUrl: workspace.cover_image_url
        }
      }
    }
  end
end

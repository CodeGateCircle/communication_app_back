class WorkspacesController < ApplicationController
  # before_action :authenticate_user!

  def create
    params = create_params

    workspace = Workspace.create!({
      name: params[:name],
      description: params[:description],
      icon_image_url: params[:iconImageUrl],
      cover_image_url: params[:coverImageUrl],
    })

    render status: 200, :json => { data: { workspace: workspace.format_res } }
  end

  # strong parameter
  def create_params
    params.require(:workspace).permit(:name, :description, :iconImageUrl, :coverImageUrl)
  end
end
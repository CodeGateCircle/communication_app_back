class WorkspacesController < ApplicationController
  # before_action :authenticate_user!

  def create
    params = create_params

    workspace = Workspace.create!(params)

    render :json => { data: workspace }
  end

  # strong parameter
  def create_params
    params.require(:workspace).permit(:name, :description, :iconImageUrl, :coverImageUrl)
  end
end
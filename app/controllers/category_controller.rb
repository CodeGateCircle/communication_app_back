class CategoryController < ApplicationController
  before_action :authenticate_user!

  def create
    params = create_params
    if auth_workspace_edit(params[:workspaceId])
      render status: 401, text: "cannot edit category of workspace without auth"
    else
      category = Category.create!({
                                      name: params[:name],
                                      workspace_id: params[:workspaceId]
                                  })

      render status: 200, json: { data: { category: category.format_res } }
    end
  end

  private

  def create_params
    params.permit(:category_id, :name, :workspaceId)
  end

  def auth_workspace_edit(workspace_id)
    !current_user.workspaces.exists?(id: workspace_id)
  end

  def auth_edit_with_categoryid
    params[:workspaceId] = Category.find(params[:category_id]).workspace_id
    auth_workspace_edit(params[:workspaceId])
  end
end

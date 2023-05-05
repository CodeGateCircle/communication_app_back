class CategoryController < ApplicationController
  before_action :authenticate_user!

  def create
    params = create_params
    if auth_workspace_edit
      render status: 401, text: "cannot edit category of workspace without auth"
    else
      category = Category.create!({
                                      name: params[:name],
                                      workspace_id: params[:workspaceId]
                                  })

      render status: 200, json: { data: { category: category.format_res } }
    end
  end

  def update
    params = create_params
    if auth_workspace_edit
      render status: 401, text: "cannot edit category of workspace without auth"
    else
      category = Category.find(params[:category_id])
      category.update!({ name: params[:name] })

      render status: 200, json: { data: { category: category.format_res } }
    end
  end

  private

  def create_params
    params.permit(:category_id, :name, :workspaceId)
  end

  def auth_workspace_edit
    user = WorkspaceUser.find_by(workspace_id: params[:workspaceId])

    user.user_id != current_user.id
  end
end

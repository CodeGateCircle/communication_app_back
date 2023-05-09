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
    users = WorkspaceUser.where(workspace_id: workspace_id)

    if !current_user.workspaces.exists?(id: workspace_id)
      true
    else
      flag = false
      users.each do |user|
        if user.user_id != current_user.id # eq -> true, ne -> false
          flag = true
          break
        end
      end
      flag
    end
  end

  def auth_edit_with_categoryid
    params[:workspaceId] = Category.find(params[:category_id]).workspace_id
    auth_workspace_edit(params[:workspaceId])
  end
end

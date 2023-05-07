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

  def index
    params = create_params
    if auth_workspace_edit
      render status: 401, text: "cannot edit category of workspace without auth"
    else
      categories = Category.where(workspace_id: params[:workspaceId])

      render status: 200, json: { data: { categories: categories.map(&:format_res) } }
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

  def delete
    params = create_params
    if auth_edit_with_categoryid
      render status: 401, text: "cannot edit category of workspace without auth"
    else
      if not Room.find_by(category_id: params[:category_id])
        category = Category.find(params[:category_id])
        category.destroy!

        render status: 200, json: { success: true }
      else
        render status: 401, text: "some rooms in this category exist, so cannot delete category"
      end
    end
  end

  private

  def create_params
    params.permit(:category_id, :name, :workspaceId)
  end

  def auth_workspace_edit
    params = create_params
    user = WorkspaceUser.find_by(workspace_id: params[:workspaceId])
    if user.blank? # blank -> true -> false
      true
    else
      user.user_id != current_user.id # eq -> true, ne -> false
    end
  end

  def auth_edit_with_categoryid
    params[:workspaceId] = Category.find(params[:category_id]).workspace_id
    auth_workspace_edit
  end
end

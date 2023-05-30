# Category
class CategoryController < ApplicationController
  before_action :authenticate_user!
  before_action :belong_to_workspace?, only: %i[create index update]

  def create
    params = create_params
    # if belong_to_workspace?(params[:workspace_id])
    #   render status: 401, text: "cannot edit category of workspace without auth"
    #   return
    # end

    category = Category.create!({
                                  name: params[:name],
                                  workspace_id: params[:workspace_id]
                                })

    render status: 200, json: category
  end

  def index
    params = index_params
    # if belong_to_workspace?(params[:workspace_id])
    #   render status: 401, text: "cannot edit category of workspace without auth"
    #   return
    # end

    categories = Category.where(workspace_id: params[:workspace_id])

    render status: 200, json: categories, each_serializer: CategorySerializer
  end

  def update
    params = update_params
    # if belong_to_workspace?(params[:workspace_id])
    #   render status: 401, text: "cannot edit category of workspace without auth"
    #   return
    # end

    category = Category.find(params[:category_id])
    category.update!({ name: params[:name] })

    render status: 200, json: category
  end

  def delete
    params = delete_params
    workspace_id = Category.find(params[:category_id]).workspace_id
    if guest_belong_to_workspace?(workspace_id, current_user.id)
      render status: 401, text: "cannot edit category of workspace without auth"
      return
    end

    if Room.find_by(category_id: params[:category_id])
      render status: 401, text: "some rooms in this category exist, so cannot delete category"
      return
    end

    category = Category.find(params[:category_id])
    category.destroy!

    render status: 200, json: { success: true }
  end

  private

  def create_params
    params.permit(:category_id, :name, :workspace_id)
  end

  def index_params
    params.permit(:workspace_id)
  end

  def update_params
    params.permit(:category_id, :name, :workspace_id)
  end

  def delete_params
    params.permit(:category_id, :workspace_id)
  end

  def auth_edit_with_categoryid
    workspace_id = Category.find(params[:category_id]).workspace_id
    belong_to_workspace?(workspace_id)
  end
end

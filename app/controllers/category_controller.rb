class CategoryController < ApplicationController
  before_action :authenticate_user!

  def create
    params = create_params

    Category.transaction do
      category = Category.create!({
                                      name: params[:name],
                                      workspace_id: params[:workspace_id]
                                  })
      category.save!

      render status: 200, json: { data: { category: category.format_res } }
    end
  end

  def update
    params = create_params

    Category.transaction do
      category = Category.find(params[:category_id])
      category.update!({
                         name: params[:name],
                         workspace_id: params[:workspace_id]
                       })
      render status: 200, json: { data: { category: category.format_res } }
    end
  end

  private

  def create_params
    params.permit(:category_id, :name, :workspace_id)
  end
end
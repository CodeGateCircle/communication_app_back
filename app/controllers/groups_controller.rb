# group
class GroupsController < ApplicationController
  before_action :authenticate_user!

  def create
    params = create_params

    Group.transaction do
      group = Group.create!({
                              name: params[:name],
                              description: params[:description],
                              icon_image_url: params[:iconImageUrl],
                              workspace_id: params[:workspaceId]
                            })

      group_user = GroupUser.new({
                                    workspace_id: group[:workspace_id],
                                    user_id: current_user.id,
                                    group_id: group[:id]
                                  })
      group_user.save!

      render status: 200, json: { data: { group: group.format_res } }
    end
  end

  private

  # strong parameter
  def create_params
    params.permit(:name, :description, :iconImageUrl, :workspaceId)
  end
end

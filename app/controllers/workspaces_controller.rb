# workspace
class WorkspacesController < ApplicationController
  before_action :authenticate_user!

  def index
    workspaces = current_user.workspaces.order(id: :asc)
    render json: workspaces, each_serializer: WorkspaceSerializer
  end

  def create
    params = create_params

    Workspace.transaction do
      workspace = Workspace.create!({
                                      name: params[:name],
                                      description: params[:description],
                                      icon_image_url: params[:icon_image_url],
                                      cover_image_url: params[:cover_image_url]
                                    })

      workspace_user = WorkspaceUser.new({
                                           workspace_id: workspace[:id],
                                           user_id: current_user.id
                                         })
      workspace_user.save!

      render status: 200, json: workspace
    end
  end

  def update
    params = create_params

    Workspace.transaction do
      workspace = Workspace.find(params[:workspace_id])
      workspace.update!({
                          name: params[:name],
                          description: params[:description],
                          icon_image_url: params[:icon_image_url],
                          cover_image_url: params[:cover_image_url]
                        })

      render status: 200, json: workspace
    end
  end

  def delete
    workspace = Workspace.find(params[:workspace_id])
    workspace.destroy!

    render status: 200, json: { success: true }
  end

  def invite
    # params[:user_id]...man who send invitation
    params = invite_params

    unless User.find_by(email: params[:email])
      render status: 400, json: { status: "no user" }
      return
    end

    invitee_id = User.find_by(email: params[:email]).id

    # applicationController
    if guest_belong_to_workspace?(params[:workspace_id], current_user.id)
      render status: 401, json: { status: "no auth" }
      return
    end

    if WorkspaceUser.find_by(workspace_id: params[:workspace_id], user_id: invitee_id)
      render status: 400, json: { status: "exist now" }
      return
    end

    workspace_user = WorkspaceUser.create!({
                                             workspace_id: params[:workspace_id],
                                             user_id: invitee_id
                                           })

    render status: 200, json: workspace_user
  end

  private

  # strong parameter
  def create_params
    params.permit(:workspace_id, :name, :description, :icon_image_url, :cover_image_url)
  end

  def invite_params
    params.permit(:workspace_id, :email)
  end
end

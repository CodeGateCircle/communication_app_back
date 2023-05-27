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
    # # もし、過去に作ったURLがあるとき
    # URLをreturn
    url =
    if url && (params[:change] == false)
      {
        exist: true,
        url: url
      }
    end
    # # なかったとき
    # URLを生成する
    message = "workspace#{self.id}Pass"
    secret = SecureRandom::hex(128)
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    encrypt_message = encryptor.encrypt_and_sign(message)

    url = request.base_url + '/workspaces/invite/confirm?crypt_text=' + encrypt_message
    Invitation.create({
                        type: 'workspace',
                        this_id: self.id,
                        plain_text: encrypt_message,
                        password_digest: secret
                      })
    # return
    {
      exist: false,
      url: url
    }
  end

  def confirm
    params = confirm_param
    text_all = Invitation.where(type: 'workspace', this_id: self.id, is_deleted: false)
    flag = false
    text_all.each do |text|
      if params[:crypt_text] == text
        flag = true
        break
      end
    end

    if flag
      # { status: "Please wait..."}
      register(current_user.id)
    else
      { status: "failed because this url is not available" }
    end
  end

  private

  # strong parameter
  def create_params
    params.permit(:workspace_id, :name, :description, :icon_image_url, :cover_image_url)
  end

  def confirm_param
    params.permit(:crypt_text)
  end

  def register(current_user_id)
    if WorkspaceUser.create!({
                               workspace_id: self.id,
                               user_id: current_user_id
                             })
      render status: 200, json: { status: "success" }
    else
      render status: 400, json: { status: "failure" }
    end
  end
end

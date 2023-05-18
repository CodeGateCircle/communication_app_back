# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  @return = {}

  before_action :snake_to_camel_params

  def snake_to_camel_params
    params.deep_transform_keys!(&:underscore)
  end

  def return_format
    p @return
    render json: { data: @return }
  end

  # ユーザーがworkspaceに属しているかチェック
  def belong_to_workspace?(workspace_id)
    user = WorkspaceUser.find_by(workspace_id:, user_id: current_user.id)
    user.nil?
  end

  # ユーザーがroomに属しているかチェック
  def belong_to_room?(room_id)
    user = RoomUser.find_by(room_id:, user_id: current_user.id)
    user.nil?
  end
end

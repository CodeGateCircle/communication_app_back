# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :snake_to_camel_params

  def snake_to_camel_params
    params.deep_transform_keys!(&:underscore)
  end

  # ユーザーがworkspaceに属しているかチェック
  def belong_to_workspace?(workspace_id, user_id)
    user = WorkspaceUser.find_by(workspace_id:, user_id:)
    user.nil?
  end

  # ユーザーがroomに属しているかチェック
  def belong_to_room?(room_id, user_id)
    user = RoomUser.find_by(room_id:, user_id:)
    user.nil?
  end
end

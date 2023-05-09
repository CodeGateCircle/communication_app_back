# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

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

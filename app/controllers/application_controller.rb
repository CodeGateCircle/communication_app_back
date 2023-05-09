# application
class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  # ユーザーがworkspaceに属しているかチェック
  def belong_to_workspace?(workspace_id)
    user = WorkspaceUser.find_by(workspace_id:, user_id: current_user.id)
    user.nil?
  end
end

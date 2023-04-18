# workspace_user
class WorkspaceUser < ApplicationRecord
  belongs_to :workspace, foreign_key: :workspace_id
  belongs_to :user, primary_key: :uid, foreign_key: :uid
end

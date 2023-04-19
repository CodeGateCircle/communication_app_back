# workspace_user
class WorkspaceUser < ApplicationRecord
  belongs_to :workspace
  belongs_to :user
end

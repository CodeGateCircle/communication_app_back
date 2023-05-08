# workspace_user
class WorkspaceUser < ApplicationRecord
  belongs_to :workspace
  belongs_to :user

  enum role: { owner: 0, member: 3 }, _default: :member
end

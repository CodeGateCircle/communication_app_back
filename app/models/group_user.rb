# group_user
class GroupUser < ApplicationRecord
  belongs_to :workspace
  belongs_to :group
  belongs_to :user
end

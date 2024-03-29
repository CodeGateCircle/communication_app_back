# user
class UserSerializer < ActiveModel::Serializer
  type :user
  attributes :id, :name, :email, :image, :created_at, :updated_at
  has_many :workspaces, serializer: WorkspaceSerializer
end

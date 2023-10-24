# workspace
class WorkspaceSerializer < ActiveModel::Serializer
  type :workspace
  attributes :id, :name, :description, :icon_image_url, :cover_image_url, :created_at, :updated_at
end

# category
class CategorySerializer < ActiveModel::Serializer
  type :category

  attributes :id, :name, :workspace_id
end

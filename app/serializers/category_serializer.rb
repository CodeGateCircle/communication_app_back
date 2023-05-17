# category
class CategorySerializer < ActiveModel::Serializer
  type :category

  # rails g serializer [model name]
  attributes :id, :name, :workspace_id
end
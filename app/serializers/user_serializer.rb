class UserSerializer < ActiveModel::Serializer
  type :user

  attributes :id, :name, :email, :image, :created_at, :updated_at
  # attribute :created_at, key: :createdAt
  # attribute :updated_at, key: :updatedAt
end

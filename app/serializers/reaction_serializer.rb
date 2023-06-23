class ReactionSerializer < ActiveModel::Serializer
  type :reaction
  attributes :id, :name, :created_at, :updated_at, :user_id, :message_id
end
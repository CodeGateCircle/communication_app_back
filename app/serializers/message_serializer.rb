class MessageSerializer < ActiveModel::Serializer
  type :message
  attributes :id, :content, :created_at, :updated_at, :user_id, :room_id
end

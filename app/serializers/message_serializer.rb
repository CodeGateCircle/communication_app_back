class MessageSerializer < ActiveModel::Serializer
  type :message
  attributes :id, :content, :user, :room_id, :updated_at, :created_at

  def user
    {
      id: object.user.id,
      name: object.user.name,
      image: object.user.image
    }
  end

  def updated_at
    object.updated_at.iso8601
  end

  def created_at
    object.created_at.iso8601
  end
end

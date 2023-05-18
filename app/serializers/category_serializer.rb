# category
class CategorySerializer < ActiveModel::Serializer
  type :category

  attributes :id, :name
  attribute :workspace_id?
  has_many :room,
           each_serializer: RoomSerializer, 
           if: -> { object[:rooms].present? } do
    object[:rooms]
  end
end

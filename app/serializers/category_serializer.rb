# category
class CategorySerializer < ActiveModel::Serializer
  type :category

  attributes :id, :name
  attribute :workspace_id, if: -> { object.workspace_id.present? }
  has_many :rooms, if: -> { object[:rooms].present? && p(object) }, serializer: RoomSerializer
end

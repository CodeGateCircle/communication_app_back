# room
class RoomSerializer < ActiveModel::Serializer
  type :room
  attributes :id, :name
  attribute :description, if: -> { object.description.present? }
  attribute :category_id, if: -> { object.category_id.present? }
  attribute :workspace_id, if: -> { object.workspace_id.present? }
  attribute :is_deleted, if: -> { object.is_deleted.present? }
end

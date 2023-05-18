# frozen_string_literal: true

class RoomSerializer < ActiveModel::Serializer
  type :room

  attributes :id, :name, :description, :category_id, :workspace_id
end

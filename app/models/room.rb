# room
class Room < ApplicationRecord
  belongs_to :workspace
  belongs_to :category

  # 中間テーブル
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(workspace_id: :workspaceId)
    res.transform_keys!(category_id: :categoryId)

    res.delete(:is_deleted)
    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end

  # id, nameのみ返す
  def room_show_format_res
    res = attributes.symbolize_keys

    res.delete(:workspace_id)
    res.delete(:category_id)
    res.delete(:description)
    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end
end

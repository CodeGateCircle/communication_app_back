# room
class Room < ApplicationRecord
  belongs_to :workspace
  belongs_to :category

  # 中間テーブル
  has_many :users, through: :room_users
  has_many :room_users, dependent: :destroy

  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(workspace_id: :workspaceId)
    res.transform_keys!(category_id: :categoryId)

    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end

end

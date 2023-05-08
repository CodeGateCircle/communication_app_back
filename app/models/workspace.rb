# workspace
class Workspace < ApplicationRecord
  has_many :rooms, dependent: :destroy

  # 中間テーブル
  has_many :workspace_users, dependent: :destroy
  has_many :users, through: :workspace_users

  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(icon_image_url: :iconImageUrl)
    res.transform_keys!(cover_image_url: :coverImageUrl)

    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end
end

class Group < ApplicationRecord
  belongs_to :workspace

  # 中間テーブル
  has_many :workspaces, through: :group_users
  has_many :groups, through: :group_users

  has_many :group_users, dependent: :destroy

  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(icon_image_url: :iconImageUrl)
    res.transform_keys!(workspace_id: :workspaceId)

    res.delete(:created_at)
    res.delete(:updated_at)
  end
end

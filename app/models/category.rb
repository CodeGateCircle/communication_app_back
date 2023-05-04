# category
class Category < ApplicationRecord
  has_many :rooms, dependent: :destroy

  belongs_to :workspace

  # schema: name, created_at, updated_at, workspace_id
  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(workspace_id: :workspaceId)

    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end
end

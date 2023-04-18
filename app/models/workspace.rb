# workspace
class Workspace < ApplicationRecord
  before_create :set_uuid

  has_many :workspace_users, foreign_key: :workspace_id, dependent: :destroy
  has_many :users, through: :workspace_users

  private

  def set_uuid
    self.workspace_id = SecureRandom.uuid while workspace_id.blank? || User.find_by(id:).present?
  end

  public

  def format_res
    res = attributes.symbolize_keys
    res.transform_keys!(workspace_id: :workspaceId)
    res.transform_keys!(icon_image_url: :iconImageUrl)
    res.transform_keys!(cover_image_url: :coverImageUrl)

    res.delete(:created_at)
    res.delete(:updated_at)
    res
  end
end

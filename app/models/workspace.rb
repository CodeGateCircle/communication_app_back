class Workspace < ApplicationRecord
  before_create :set_uuid

  private
  def set_uuid
    while self.workspace_id.blank? || User.find_by(id: self.id).present? do
      self.workspace_id = SecureRandom.uuid
    end
  end

  public
  def format_res
    res = self.attributes.symbolize_keys
    res.transform_keys!(workspace_id: :workspaceId)
    res.transform_keys!(icon_image_url: :iconImageUrl)
    res.transform_keys!(cover_image_url: :coverImageUrl)

    res.delete(:created_at)
    res.delete(:updated_at)
    return res
  end
end

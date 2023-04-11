class Workspace < ApplicationRecord
  before_create :set_uuid

  private
  def set_uuid
    while self.id.blank? || User.find_by(id: self.id).present? do
      self.id = SecureRandom.uuid
    end
  end
end

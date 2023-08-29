class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_many :reactions, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }
end

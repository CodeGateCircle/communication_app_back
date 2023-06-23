class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_many :reaction, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }
end

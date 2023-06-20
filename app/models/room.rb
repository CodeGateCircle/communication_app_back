# room
class Room < ApplicationRecord
  belongs_to :workspace
  belongs_to :category, optional: true
  validates :category, presence: true, if: :category_id?

  # 中間テーブル
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_many :messages
end

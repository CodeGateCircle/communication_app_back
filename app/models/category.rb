# category
class Category < ApplicationRecord
  has_many :rooms, dependent: :destroy

  belongs_to :workspace
end

class Category < ApplicationRecord
  has_many :rooms, dependent: :destroy
end

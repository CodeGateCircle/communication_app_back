FactoryBot.define do
  factory :room_user do
    association :room
    association :user
  end
end

FactoryBot.define do
  factory :room_user do
    association :room, factory: :room_id
    association :user, factory: :user_id
  end
end

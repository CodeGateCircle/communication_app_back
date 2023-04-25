FactoryBot.define do
  factory :room_user do
    room_id { Faker::Internet.password }
    user_id { Faker::Internet.password }
  end
end

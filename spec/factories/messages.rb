FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    association :room
    association :user
  end
end

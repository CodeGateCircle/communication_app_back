FactoryBot.define do
  factory :reaction do
    name { Faker::Name.name }
    association :room
    association :user
  end
end

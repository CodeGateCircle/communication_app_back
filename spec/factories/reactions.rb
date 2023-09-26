FactoryBot.define do
  factory :reaction do
    name { Faker::Name.name }
    association :message
    association :user
  end
end

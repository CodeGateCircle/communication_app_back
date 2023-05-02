FactoryBot.define do
  factory :room do
    name { Faker::Name.name }
    description { Faker::Name.name }
    association :category
    association :workspace
  end
end

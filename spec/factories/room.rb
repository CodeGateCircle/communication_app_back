FactoryBot.define do
  factory :room do
    name { Faker::Name.name }
    description { Faker::Name.name }
    is_deleted { false }
    association :category
    association :workspace
  end
end

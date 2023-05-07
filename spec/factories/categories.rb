FactoryBot.define do
  factory :category do
    name { Faker::Name.name }
    association :workspace
  end
end

FactoryBot.define do
  factory :room do
    name { Faker::Name.name }
    description { Faker::Name.name }
    association :category, factory: :category_id
    association :workspace, factory: :workspace_id
  end
end

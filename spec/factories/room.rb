FactoryBot.define do
  factory :room do
    name { Faker::Name.name }
    description { Faker::Name.name }
    category_id { 0 }
    workspace_id { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :workspace do
    workspace_id { Faker::Internet.password }
    name { Faker::Name.name }
    description { Faker::Name.name }
    icon_image_url { Faker::Internet.url }
    cover_image_url { Faker::Internet.url }
  end
end

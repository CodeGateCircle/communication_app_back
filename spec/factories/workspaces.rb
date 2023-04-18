FactoryBot.define do
  factory :workspace do
    name { Faker::Name.name }
    description { Faker::Name.name }
    icon_image_url { Faker::Internet.url }
    cover_image_url { Faker::Internet.url }
  end
end

FactoryBot.define do
  factory :group do
    name { Faker::Name.name }
    description { Faker::Name.name }
    icon_image_url { Faker::Internet.url }
    workspace_id { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { Faker::Internet.password(min_length: 6) }
    name { Faker::Name.name }
    image { Faker::Internet.url }
  end
end

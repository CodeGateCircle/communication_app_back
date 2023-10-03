FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { Faker::Internet.password(min_length: 6) }
    name { Faker::Name.name }
    # image <- add unnamed.jpg
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/unnamed.jpg')) }
  end
end

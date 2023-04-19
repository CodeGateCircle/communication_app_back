FactoryBot.define do
  factory :workspace_user do
    workspace_id { Faker::Internet.password }
    user_id { Faker::Internet.password }
  end
end

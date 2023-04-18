FactoryBot.define do
  factory :workspace_user do
    workspace_id { Faker::Internet.password }
    uid { Faker::Internet.password }
  end
end

FactoryBot.define do
  factory :group_user do
    workspace_id { Faker::Internet.password }
    group_id { Faker::Internet.password }
    user_id { Faker::Internet.password }
  end
end

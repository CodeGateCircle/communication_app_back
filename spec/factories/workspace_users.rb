FactoryBot.define do
  factory :workspace_user do
    association :workspace, factory: :workspace_id
    association :user, factory: :user_id
  end
end

FactoryBot.define do
  factory :workspace_user do
    role  { :owner }
    association :workspace
    association :user
  end
end

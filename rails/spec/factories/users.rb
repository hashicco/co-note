FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email){ |n| "User#{n}@example.com" }
  end
end

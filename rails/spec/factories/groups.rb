FactoryBot.define do
  factory :group do
    name "GroupHogeHoge"

    trait :with_including_users do
      transient do
        users []
      end
  
      after(:build) do |group, evaluator|
        evaluator.users.each do |user|
          group.group_users.build user: user
        end
      end
    end
  end
end

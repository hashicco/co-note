FactoryBot.define do
  factory :note do
    title "hoge"
    text "hogehoge\nhogehoge\nhogehoge"
    disclosed_to_public false

    trait :with_disclosed_groups do
      transient do
        groups []
      end
  
      after(:build) do |note, evaluator|
        evaluator.groups.each do |group|
          note.disclosures.build group: group
        end
      end
    end

  end
end

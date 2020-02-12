FactoryBot.define do
  factory :score_record do
    score { 100 }
    mistake_ids { ["1", "2"]}
    corrent_ids { ["3"] }

    trait :invalid do
      score { "" }
    end
  end
end

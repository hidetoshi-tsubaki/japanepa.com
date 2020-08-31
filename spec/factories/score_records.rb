FactoryBot.define do
  factory :score_record do
    score { 100 }
    title_id { 1 }

    trait :invalid do
      score { "" }
    end
  end
end

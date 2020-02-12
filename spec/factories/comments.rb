FactoryBot.define do
  factory :comment do
    user_id { "1" }
    talk_id { "1" }
    contents { "comment test" }
  end

  trait :invalid do
    contents = nil
  end

  factory :comment_A, class: Comment do
    user_id { "1" }
    talk_id { "1" }
    contents { "comment test_a" }
  end
end

FactoryBot.define do
  factory :quiz do
    sequence(:question) { |n| "question_" + n.to_s }
    sequence(:question_html) { |n| "<p>question_" + n.to_s + "</p>" }
    choice1 { "a" }
    choice2 { "i" }
    choice3 { "u" }
    choice4 { "o" }
    category_id { "1" }

    trait :invalid do
      question { "" }
      choice1 { "" }
    end
  end

  factory :quiz_A, class: Quiz do
    question { "カタカナ" }
    question_html { "<p>カタカナ</p>" }
    choice1 { "ア" }
    choice2 { "イ" }
    choice3 { "ウ" }
    choice4 { "オ" }
    category_id { "1" }
  end
end

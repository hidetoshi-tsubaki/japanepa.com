FactoryBot.define do
  factory :quiz do
    sequence(:question) { |n| "question_#{n}" }
    sequence(:question_html) { |n| "<p>question_#{n}</p>" }
    choice1 { "a" }
    choice2 { "i" }
    choice3 { "u" }
    choice4 { "o" }

    trait :invalid do
      question { "" }
      choice1 { "" }
    end

    trait :update do
      question_html { "<p>updated</p>" }
    end

    trait :last do
      question { "wwww" }
      choice1 { "wwww" }
      choice2 { "wwww" }
      choice3 { "wwww" }
      choice4 { "wwww" }
    end
  end
end

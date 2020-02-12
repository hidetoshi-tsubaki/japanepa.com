FactoryBot.define do
  factory :mistake do
  end

  # factory :quiz, class: Quiz do
  #   question { "ひらがな" }
  #   question_html { "<p>あ</p>" }
  #   choice1 { "a" }
  #   choice2 { "i" }
  #   choice3 { "u" }
  #   choice4 { "o" }
  #   category_id { "1" }
  # end

  # factory :user, class: User do
  #   name { "test user" }
  #   country { "JP" }
  #   current_address { "JP" }
  #   password { "japanepa19" }
  #   password_confirmation { "japanepa19" }
    
  #   after(:create) do |user|
  #     user.user_total_experiences << build(:user_total_experience)
  #   end
  # end

  # factory :title, class: QuizCategory do
  #   name { "category" }
  # end
end

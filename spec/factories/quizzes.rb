FactoryBot.define do
  factory :quiz do
    question "あ"
    question_html "<p>あ</p>"
    choice1 "a"
    choice2 "i"
    choice3 "u"
    choice4 "o"
    category_id "1"
  end
end

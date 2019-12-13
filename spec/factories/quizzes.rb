FactoryBot.define do
  factory :quiz do
    question { "あ" }
    question_html { "<p>あ</p>" }
    choice1 { "a" }
    choice2 { "i" }
    choice3 { "u" }
    choice4 { "o" }
    category_id { "1" }
  end

  factory :quiz_A, class: Quiz do
    title { "japan" }
    lead { "study in japan" }
    content { "<p>study in japan</p>" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end
end

FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "japanese_#{n}" }
    sequence(:contents) { |n| "<p>How to study Japanese#{n}</p>" }
    sequence(:lead) { |n| "Do you know how to study japanese#{n}" }
    status { "published" }
    after(:build) do |article|
      article.img.attach(io: File.open(
        Rails.root.join('spec', 'factories', 'images', 'img.png')
      ), filename: 'img.png', content_type: 'image/png')
    end

    trait :invalid do
      title { "" }
    end

    trait :last do
      title { "wwwww" }
      contents { "wwwwwww" }
      lead { "wwwww" }
      impressions_count { "100" }
      bookmarks_count { "100" }
      likes_count { "100" }
    end

    trait :update do
      title { "updated" }
    end
  end
end

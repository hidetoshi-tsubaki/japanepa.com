FactoryBot.define do
  factory :article do
    title { "japanese" }
    contents { "<p>How to study Japanese</p>" }
    lead { "Do you know how to study japanese" }
    status { "published" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end

    trait :invalid do
      title { "" }
    end
  end

  factory :article_A, class: Article do
    title { "japan" }
    lead { "study in japan" }
    contents { "<p>study in japan</p>" }
    status { "published" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end

  factory :article_B, class: Article do
    title { "nepal" }
    lead { "study japanese before go to japan" }
    contents { "<p>first you have to stuby japanese words</p>" }
    status { "published" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end

end

FactoryBot.define do
  factory :article do
    title { "japanese" }
    contents { "<p>How to study Japanese</p>" }
    lead { "Do you know how to study japanese" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end
end

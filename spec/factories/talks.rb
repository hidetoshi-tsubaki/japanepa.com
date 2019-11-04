FactoryBot.define do
  factory :talk do
    user_id "1"
    community_id "1"
    content "talk test"
    after(:build) do |talk|
      talk.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end
end

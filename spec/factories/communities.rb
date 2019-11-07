FactoryBot.define do
  factory :community do
    name { "community_test" }
    introduction { "introduction_test" }
    founder_id { "1" }
    after(:build) do |community|
      community.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end
end

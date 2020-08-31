FactoryBot.define do
  factory :community do
    sequence(:name) { |n| "community_#{n}" }
    introduction { "introduction_test" }
    after(:build) do |community|
      community.img.attach(io: File.open(
        Rails.root.join('spec', 'factories', 'images', 'img.png')
      ), filename: 'img.png', content_type: 'image/png')
    end

    trait :with_founder do
      after(:build) do |community|
        community.founder = create(:user)
      end
    end

    trait :with_founder_id do
      founder_id { "1" }
    end

    trait :update do
      founder_id { "1" }
      name { "updated_community" }
    end

    trait :last do
      name { "wwww" }
      introduction { "www" }
      member_count { 100 }
      talk_count { 100 }
      after(:build) do |community|
        community.founder = create(:user, name: "wwwww")
      end
    end

    trait :invalid do
      name { "" }
    end
  end
end

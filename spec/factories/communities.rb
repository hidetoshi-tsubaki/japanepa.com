FactoryBot.define do
  factory :community do
    name { "community_test" }
    introduction { "introduction_test" }
    founder_id { 1 }
    after(:build) do |community|
      community.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end

    trait :with_founder do
      founder
    end

    trait :with_founder_2 do
      founder
      name { "community_test_2" }
    end

    trait :update do
      name { "updated_community"}
    end

    trait :invalid do
      name { "" }
    end
  end

  factory :founder, class: User do
    name { "japanepa" }
    country { "JP" }
    current_address { "JP" }
    password { "japanepa1" }
    password_confirmation { "japanepa1" }
  end

  factory :community_A, class: Community do
    name { "community_test_A" }
    introduction { "this is funny community group" }
    founder_id { "1" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end

  factory :community_B, class: Community do
    name { "community_b" }
    introduction { "this is awesome community group" }
    founder_id { "1" }
    after(:build) do |article|
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
    end
  end
end

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    password { "japanepa" }
    password_confirmation { "japanepa" }
    country { "JP" }
    current_address { "JP" }

    trait :with_related_model do
      after(:create) do |user|
        create(:user_experience, user: user)
      end
    end

    trait :invalid do
      name { "" }
    end

    trait :update do
      name { "updated user" }
    end

    trait :founder do
      name { "founder" }
    end

    trait :last do
      name { "wwwww" }
      country { "ZW" }
      current_address { "ZW" }
      play_count { 100 }
      talk_count { 100 }
      community_count { 100 }
      after(:create) do |user|
        create(:user_experience, user: user)
      end
    end
  end
end

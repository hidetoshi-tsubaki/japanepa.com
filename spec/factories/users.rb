FactoryBot.define do
  factory :user do
    name { "test user" }
    country { "JP" }
    current_address { "JP" }
    password { "japanepa19" }
    password_confirmation { "japanepa19" }
    
    after(:create) do |user|
      user.user_total_experiences << build(:user_total_experience)
    end
    
    trait :invalid do
      name = nil
    end

    trait :update do
      name { "updated user"}
    end

    trait :founder do
      name { "founder" }
    end
  end

  factory :taro, class: User do
    name { "taro" }
    country { "JP" }
    current_address { "JP" }
    password { "japanepa20" }
    password_confirmation { "japanepa20" }

    after(:create) do |user|
      user.user_total_experiences << build(:user_total_experience)
    end

  end

  factory :arjan, class: User do
    name { "arjun" }
    country { "NP" }
    current_address { "JP" }
    password { "japanepa19" }
    password_confirmation { "japanepa19" }
  end
end

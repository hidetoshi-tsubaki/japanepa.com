FactoryBot.define do
  factory :user do
    name { "test user" }
    country { "JP" }
    current_address { "JP" }
    password { "japanepa19" }
    password_confirmation { "japanepa19" }
    
    after(:create) do |user|
      user.user_experience << build(:user_experience)
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
end

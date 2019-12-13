FactoryBot.define do
  factory :user do
    name { "japanepa" }
    country { "JP" }
    current_address { "JP" }
    password { "japanepa19" }
    password_confirmation { "japanepa19" }
  end

  factory :taro, class: User do
    name { "taro" }
    country { "JP" }
    current_address { "JP" }
  end
  factory :arjan, class: User do
    name { "arjun" }
    country { "NP" }
    current_address { "JP" }
  end
end

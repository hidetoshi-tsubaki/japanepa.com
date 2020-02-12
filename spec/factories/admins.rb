FactoryBot.define do
  factory :admin do
    name { "admin@japanepa" }
    password { "japanepa" }
    password_confirmation{ "japanepa" }
  end
end

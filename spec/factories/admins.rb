FactoryBot.define do
  factory :admin do
    name { "japanepa.com" }
    password { "japanepa" }
    password_confirmation { "japanepa" }
  end
end

FactoryBot.define do
  factory :comment do
    user_id { "1" }
    talk_id { "1" }
    contents { "comment test" }
  end
end

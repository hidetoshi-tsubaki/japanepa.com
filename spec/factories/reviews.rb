FactoryBot.define do
  factory :review do
    count { 1 }
    next_time { Date.tomorrow }
  end
end

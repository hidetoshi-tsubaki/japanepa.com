FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "event_#{n}" }
    detail { "event detail" }
    start_time { Date.today }
    end_time { Date.today }
    status { "published" }

    trait :invalid do
      name { "" }
    end

    trait :updated do
      name { "updated" }
      detail { "updated" }
      start_time { Date.today }
      end_time { Date.today }
      status { "published" }
    end

    trait :last do
      name { "www" }
      detail { "www" }
    end
  end
end

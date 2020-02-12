FactoryBot.define do
  factory :event do
    name { "new event" }
    detail { "event detail" }
    start_time { "2019-12-26 11:18:39" }
    end_time { "2019-12-26 11:18:39" }
    status { "published" }

    trait :invalid do
      name { "" }
    end
  end

  factory :event_A, class: Community do
    name { "event_a" }
    start_time { Date.today }
    end_time { Date.today }
    status { "published" }
  end

  factory :event_B, class: Community do
    name { "event_b" }
    start_time { Date.today }
    end_time { Date.today }
    status { "published" }
  end

end

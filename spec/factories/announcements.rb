FactoryBot.define do
  factory :announcement do
    title { "announce" }
    contents { "this is announcement" }
    created_at { Date.today }
    status { "published" }

    trait :invalid do
      title = nil
    end
  end

  factory :announce_A, class: Announcement do
    title { "announce_a" }
    contents { "this is announce_a"}
    created_at { Date.today }
    status { "published" }
  end
end

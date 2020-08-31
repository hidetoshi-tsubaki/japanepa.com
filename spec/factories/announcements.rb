FactoryBot.define do
  factory :announcement do
    sequence(:title) { |n| "announce_#{n}" }
    sequence(:contents) { |n| "announce contents_#{n}" }
    status { "published" }

    trait :invalid do
      title { "" }
      contents { "" }
    end

    trait :last do
      title { "wwww" }
      contents { "wwww" }
      impressions_count { 100 }
    end

    trait :update do
      title { "updated" }
    end
  end
end

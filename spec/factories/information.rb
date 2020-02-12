FactoryBot.define do
  factory :information do
    title { "info" }
    contents { "this is information" }
    created_at { Date.today }
    status { "published" }

    trait :invalid do
      title = nil
    end
  end

  factory :info_A, class: Information do
    title { "info_a" }
    contents { "this is info_a"}
    created_at { Date.today }
    status { "published" }
  end
end

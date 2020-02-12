FactoryBot.define do
  factory :category_parent, class: QuizCategory do
    name { "category_parent" }

    trait :invalid do
      name { "" }
    end

    trait :created do
      name { "category_parent_created" }
    end

    trait :update do
      name { "category_parent_A"}
    end
  end
  factory :category_child, class: QuizCategory do
    name { "category_child" }
  end

  factory :category_grandchild, class: QuizCategory do
    name { "category_grandchild" }

    after(:create) do |quiz_category|
      create(:quiz_experience, title_id: quiz_category.id, experience: "2.0")
    end
  end
end

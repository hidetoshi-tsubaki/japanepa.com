FactoryBot.define do
  factory :quiz_category, class: "QuizCategory" do
    sequence(:name) { |n| "category_#{n}" }

    trait :invalid do
      name { "" }
    end

    trait :created do
      name { "category_parent_created" }
    end

    trait :update do
      name { "updated" }
    end
  end

  factory :section, class: "QuizCategory" do
    name { "category_child" }
  end

  factory :title, class: "QuizCategory" do
    name { "category_grandchild" }

    trait :with_related_model do
      after(:build) do |quiz_category|
        quiz_category.quiz_experience = create(:quiz_experience)
      end
    end
  end
end

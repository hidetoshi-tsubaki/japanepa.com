FactoryBot.define do
  factory :comment do
    sequence(:contents) { |n| "comment_#{n}" }

    after(:build) do |comment|
      comment.user = create(:user)
      comment.talk = create(:talk, :with_related_model)
    end

    trait :invalid do
      contents { "" }
    end
  end

  factory :comment_A, class: "Comment" do
    user_id { "1" }
    talk_id { "1" }
    contents { "comment test_a" }
  end
end

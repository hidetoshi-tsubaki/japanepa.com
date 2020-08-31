FactoryBot.define do
  factory :like_talk do
    user_id { "1" }
    talk_id { "1" }

    trait :with_related_model do
      after(:build) do |like_talk|
        like_talk.user = create(:user)
        like_talk.talk = create(:talk)
      end
    end
  end
end

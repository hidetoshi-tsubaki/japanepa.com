FactoryBot.define do
  factory :community_user do
    user_id { 1 }
    community_id { 1 }

    trait :with_related_model do
      after(:build) do |community_user|
        community_user.user = create(:user)
        community_user.community = create(:community, :with_founder)
      end
    end
  end
end

FactoryBot.define do
  factory :mistake do
    trait :with_related_model do
      after(:build) do |mistake|
        mistake.user = create(:user)
      end
    end
  end
end

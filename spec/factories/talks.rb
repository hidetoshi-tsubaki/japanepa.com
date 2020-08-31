FactoryBot.define do
  factory :talk do
    user_id { "1" }
    community_id { "1" }
    sequence(:content) { |n| "talk test#{n}" }

    trait :with_related_model do
      after(:build) do |talk|
        talk.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'img.png')), filename: 'img.png', content_type: 'image/png')
        talk.community = create(:community, :with_founder)
        talk.user = create(:user)
      end
    end

    trait :invalid do
      content { "" }
    end

    trait :update do
      content { "updated" }
    end
  end
end

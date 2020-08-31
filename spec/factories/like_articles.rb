FactoryBot.define do
  factory :like_article do
    user_id { "1" }
    article_id { "1" }

    trait :with_related_model do
      after(:build) do |like_article|
        like_article.user = create(:user)
        like_article.article = create(:article)
      end
    end
  end
end

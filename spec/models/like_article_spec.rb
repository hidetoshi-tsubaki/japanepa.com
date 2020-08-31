require 'rails_helper'
RSpec.describe LikeArticle, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:article) { create(:article) }
  let(:like_article) { build(:like_article, :with_related_model) }
  let!(:existing_like_article) { create(:like_article, user_id: user2.id, article_id: article.id) }

  it "is valid with user_id and article_id" do
    expect(like_article).to be_valid
  end

  it "is invalid without user_id" do
    like_article.user_id = nil
    like_article.valid?
    expect(like_article.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without article_id" do
    like_article.article_id = nil
    like_article.valid?
    expect(like_article.errors[:article_id]).to include "can't be blank"
  end

  context "when LikeArticle already exists" do
    it "is invalid with same user_id and article_id" do
      like_article2 = build(:like_article, user_id: user2.id, article_id: article.id)
      like_article2.valid?
      expect(like_article2.errors[:user_id]).to include "has already been taken"
    end
  end
end

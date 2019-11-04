require 'rails_helper'

RSpec.describe LikeArticle, type: :model do
  before do
    @user = create(:user)
    @article = create(:article)
    @like_article = LikeArticle.new(
      user_id: @user.id,
      article_id: @article.id
      )
  end

  it "is valid with user_id and article_id" do
    expect(@like_article).to be_valid
  end

  it "is invalid without user_id" do
    @like_article.user_id = nil
    expect(@like_article).not_to be_valid
  end

  it "is invalid without article_id" do
    @like_article.article_id = nil
    expect(@like_article).not_to be_valid
  end

  describe "when LikeArticle already exists" do
    it "is invalid with same user_id and article_id" do
      like_article1 = create(:like_article)
      like_article2 = build(:like_article)
      expect(like_article2).not_to be_valid
    end
  end
end

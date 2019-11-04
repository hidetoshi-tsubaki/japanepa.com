require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  before(:each) do
    @user = create(:user)
    @article = create(:article)
    @bookmark = Bookmark.new(
      user_id: @user.id,
      article_id: @article.id
      )
  end

  it "is valid with user_id and article_id" do
    expect(@bookmark).to be_valid
  end

  it "is invalid without user_id" do
    @bookmark.user_id = nil
    expect(@bookmark).not_to be_valid
  end

  it "is invalid without article_id" do
    @bookmark.article_id = nil
    expect(@bookmark).not_to be_valid
  end

  describe "when bookmark already exists" do
    it "is invalid with same user_id and article_id" do
      bookmark1 = create(:bookmark)
      bookmark2 = build(:bookmark)
      expect(bookmark2).not_to be_valid
    end
  end
end

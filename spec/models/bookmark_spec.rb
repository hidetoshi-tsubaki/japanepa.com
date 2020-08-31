require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let!(:article) { create(:article) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:bookmark) { build(:bookmark, user_id: user.id, article_id: article.id) }
  let!(:existing_bookmark) { create(:bookmark, user_id: user2.id, article_id: article.id) }

  it "is valid with user_id and article_id" do
    expect(bookmark).to be_valid
  end

  it "is invalid without user_id" do
    bookmark.user_id = nil
    bookmark.valid?
    expect(bookmark.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without article_id" do
    bookmark.article_id = nil
    bookmark.valid?
    expect(bookmark.errors[:article_id]).to include "can't be blank"
  end

  context "when bookmark already exists" do
    it "is invalid with same article id" do
      bookmark2 = build(:bookmark, user_id: user2.id, article_id: article.id)
      bookmark2.valid?
      expect(bookmark2.errors[:user_id]).to include "has already been taken"
    end
  end
end

require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let!(:article) { create(:article) }

  before do
    sign_in user
  end

  describe "Post #create" do
    context "bookmark article normally" do
      it "has success to request" do
        post bookmarks_url, params: { id: article.id }, xhr: true
        expect(response).to have_http_status 200
      end

      it "has success to bookmark" do
        post bookmarks_url, params: { id: article.id }, xhr: true
        expect(article.bookmarks.count).to eq 1
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      post bookmarks_url, params: { id: article.id }, xhr: true
      delete bookmark_url article, format: :js
      expect(response).to have_http_status 200
    end

    it "delete bookmark" do
      post bookmarks_url, params: { id: article.id }, xhr: true
      expect(article.bookmarks.count).to eq 1
      delete bookmark_url article, format: :js
      expect(article.bookmarks.count).to eq 0
    end
  end
end

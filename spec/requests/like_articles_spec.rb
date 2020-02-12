require 'rails_helper'

RSpec.describe "LikeArticles", type: :request do
  let(:user) { create(:user) }
  let(:article){ create (:article) }
  before do
    sign_in user
  end

  describe "Post #create" do
    context "like article normally" do
      it "has success to request" do
        post like_articles_url, params:{ id: article.id }, xhr: true
        expect(response).to have_http_status 200
      end

      it "has success to like_article" do
        post like_articles_url, params:{ id: article.id }, xhr: true
        expect(article.like_articles.count).to eq 1
      end
    end
  end

  describe "DELETE #destroy" do
  before{
    post like_articles_url, params: {id: article.id }, xhr: true
  }
    it "has success to request" do
      delete like_article_url article, format: :js
      expect(response).to have_http_status 200
    end

    it "delete like_article" do
      post like_articles_url, params:{ id: article.id }, xhr: true
      expect(article.like_articles.count).to eq 1
      delete like_article_url article, format: :js
      expect(article.like_articles.count).to eq 0
    end
  end
end
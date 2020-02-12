require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
  let(:admin) { create(:admin) }
  let(:article){ create (:article) }
  before do
    sign_in admin
  end
  describe "GET #index" do
    it "has success to request" do
      get admin_articles_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display article titles" do
      get admin_articles_url
      expect(response.body).to include "japanese"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_article_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    let(:article){ create :article }

    it "has success to request" do
      get edit_admin_article_url article
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display article title" do
      get edit_admin_article_url article
      expect(response.body).to include "japanese"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_articles_url, params: { article: attributes_for(:article) }
        expect(response).to have_http_status 302
      end

      it "has success to register article" do
        expect {
          post admin_articles_url, params: { article: attributes_for(:article) }
        }.to change(Article, :count).by(1)
      end

      it "redirect to article index page" do
        post admin_articles_url, params: { article: attributes_for(:article) }
        expect(response).to redirect_to admin_articles_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_articles_url, params: { article: attributes_for(:article, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "failed to register article" do
        expect do
          post admin_articles_url, params: { article: attributes_for(:article, :invalid) }
        end.to_not change(Article, :count)
      end

      it 'display error message' do
        post admin_articles_url, params: { article: attributes_for(:article, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_article_url article, params: { article: attributes_for(:article_A) }
        expect(response).to have_http_status 302
      end

      it "has success to update article title" do
        expect do
          put admin_article_url article, params: { article: attributes_for(:article_A) }
        end.to change { Article.find(article.id).title }.from('japanese').to("japan")
      end

      it "redirect to index page" do
        put admin_article_url article, params: { article: attributes_for(:article_A) }
        expect(response).to redirect_to(admin_articles_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        }.to_not change{ Article.find(article.id)}, :title
      end

      it "display error message" do
        put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_article_url article, xhr: true
      expect(response).to have_http_status 302
    end

    it "does not display deleted article" do
      delete admin_article_url article, xhr: true
      expect(response).to have_http_status 302
    end

    it "delete article" do
      article = create(:article)
      expect {
        delete admin_article_url article, xhr: true
      }.to change(Article, :count).by(-1)
    end
  end
end
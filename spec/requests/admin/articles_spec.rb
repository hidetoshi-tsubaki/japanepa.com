require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
  let(:admin) { create(:admin) }
  let!(:article) { create(:article) }
  let!(:img) { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/factories/images/img.png"), 'image/png') }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_articles_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display article titles" do
      get admin_articles_url
      expect(response.body).to include article.title
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_article_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_admin_article_url article
      expect(response).to be_successful
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
        post admin_articles_url, params: { article: attributes_for(:article, img: img) }
        expect(response).to have_http_status 302
      end

      it "has success to register article" do
        expect do
          post admin_articles_url, params: { article: attributes_for(:article, img: img) }
        end.to change(Article, :count).by(1)
      end

      it "redirect to article index page" do
        post admin_articles_url, params: { article: attributes_for(:article, img: img) }
        expect(response).to redirect_to admin_articles_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_articles_url, params: { article: attributes_for(:article, :invalid) }
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "failed to register article" do
        expect do
          post admin_articles_url, params: { article: attributes_for(:article, :invalid) }
        end.not_to change(Article, :count)
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
        put admin_article_url article, params: { article: attributes_for(:article, :update) }
        expect(response).to have_http_status 302
      end

      it "has success to update article title" do
        expect do
          put admin_article_url article, params: { article: attributes_for(:article, :update) }
        end.to change { Article.find(article.id).title }.from(article.title).to("updated")
      end

      it "redirect to index page" do
        put admin_article_url article, params: { article: attributes_for(:article, :update) }
        expect(response).to redirect_to(admin_articles_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect do
          put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        end.not_to change { Article.find(article.id) }, :title
      end

      it "display error message" do
        put admin_article_url article, params: { article: attributes_for(:article, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_article_url article, format: :js
      expect(response).to have_http_status 200
    end

    it "delete article" do
      expect do
        delete admin_article_url article, format: :js
      end.to change(Article, :count).by(-1)
    end
  end
end

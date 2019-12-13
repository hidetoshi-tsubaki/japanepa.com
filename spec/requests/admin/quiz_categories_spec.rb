require 'rails_helper'

RSpec.describe "Admin::QuizCategory", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :category_A
      FactoryBot.create :category_B
    end
  end
    it "has success to request" do
      get admin_quiz_categories_url
      expect(response.status).to eq(200)
    end

    it "display category names" do
      get admin_quiz_categories_url
      expect(response).to include "category_a"
      expect(response).to include "category_b"
    end
  end

  describe "GET #categories" do
    before do
      let(:category_A) { FactoryBot.create :category_A }
      let(:children_A) { FactoryBot.create(:category, parent_id: category_A) }
    end
  end
    it "has success to request" do
      get categories_admin_quiz_category_url children_A
      expect(response.status).to eq(200)
    end

    it "display category name" do
      get admin_quiz_categories_url
      expect(response).to include "children_A"
    end
  end

  describe "Get #new_level" do
    it "has success to request" do
      get new_level_admin_quiz_category_url
      expect(response.status).to eq 200
    end

    it  "display Form title" do
      get new_level_admin_quiz_category_url
      expect(response).to include "Category Form" 
    end
  end

  describe "Get #new_category" do
    it "has success to request" do
      get new_category_admin_quiz_category_url
      expect(response.status).to eq 200
    end

    it "display Form title" do
      get new_category_admin_quiz_category_url
      expect(response).to include "Category Form"
  end

  describe "Get #new_quiz" do
    it "has success to request" do
      get new_quiz_admin_quiz_category_url
      expect(response.status).to eq 200
    end

    it "display Form title" do
      get new_quiz_admin_quiz_category_url
      expect(response).to include "Quiz Form"
    end
  end

  describe "GET #edit" do
    let(:category_A) { FactoryBot.create :category_A }

    it "has success to request" do
      get edit_admin_quiz_category_url
      expect(response.status).to eq 200
    end

    it "display category name" do
      get edit_admin_article_url article_A
      expect(respose.body).to include "japan"
    end

    it "display country" do
      get edit_admin_article_url article_A
      expect(response.body).to include "japan"
    end
  end

  describe "GET #edit" do
    let(:article_A) { FactoryBot.create :article_A }

    it "has success to request" do
      get edit_admin_article_url
      expect(response.status).to eq 200
    end

    it "display article title" do
      get edit_admin_article_url article_A
      expect(respose.body).to include "japan"
    end

    it "display country" do
      get edit_admin_article_url article_A
      expect(response.body).to include "japan"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_articles_url, params: { article: FactoryBot.attributes_for(:article) }
        expect(response.status).to eq 302
      end

      it "has success to register article" do
        expect do
          post admin_articles_url, params: { article: FactoryBot.attributes_for(:article) }
        end.to change(Article, :count).by(1)
      end

      it "redirect to admin index page" do
        post admin_articles_url, params: { aticle: FactoryBot.attributes_for(:article) }
        expect(response).to redirect_to(admin_articles_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_articles_url, params: { article: FactoryBot.attributes_for(:user :invalid) }
        expect(response.status).to eq 200
      end

      it "failed to register user" do
        expect do
          post admin_articles_url, params: { article: FactoryBot.attributes_for(:user :invalid) }
        end.to_not change(User, :count)
      end

      it "display"
      # formの一番上に入力が間違っています。　正確に入力してくださいを表示させる
      # それが表示されていたら登録失敗とする
    end
  end

  describe "PUT #update" do
    let(:article_A) { FactoryBot.create :article_A }

    context "when paramater is valid" do
      it "has success to request" do
        post admin_article_url article_A, params: { article: FactoryBot.attributes_for(:arjan) }
        expect(response.status).to eq 302
      end

      it "has success to update article title" do
        expect do
          post admin_article_url article_A, params: { article: FactoryBot.attributes_for(:article_B) }
        end.to change { Article.find(article_A.id).title }.from('japan').to("nepal")
      end

      it "redirect to show page" do
        post admin_article_url article_A, params: { article: FactoryBot.attributes_for(:article_B) }
        expect(response).to redirect_to(admin_article_url)
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        patch admin_article_url article_A, params: { article: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it "name does not be changed" do
        expect do
        patch admin_article_url article_A, params: { article: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(Article.find(aticle_A.id)), :title
      end

      it "display error message" do

      end
    end
  end

  describe "DELETE #destroy" do
    let!(:article) { FactoryBot.create :article}

    it "has success to request" do
      delete admin_article_url article
      expect(response.status).to eq 302
    end

    it "delete user" do
      expect do
        delete user_registration_url article
      end.to change(Article, :count).by(-1)
    end

    it "redirect to index page" do
      delete admin_article_url article
      expect(response).to redirect_to(admin_articles_url)
    end
  end
end
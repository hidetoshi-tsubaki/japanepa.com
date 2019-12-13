require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :article_A
      FactoryBot.create :article_B
    end
  end
    it "has success to request" do
      get admin_users_url
      expect(response.status).to eq(200)
    end

    it "display article titles" do
      get adminusers_url
      expect(response).to include "japan"
      expect(response).to include "nepal"
    end
  end

  # プレビュー画面のボタンを入れる
  # describe "GET :show" do
  #   context "if user exist" do
  #     let(:article1) { FactoryBot.create :taro }

  #     it "has success to request" do
  #       get user_url taro.id
  #       expect (response.status).to eq 200
  #     end

  #     it "display user_name" do
  #       get  user_url taro.id
  #       expect (response.body).to include "taro"
  #     end

  #     context "if user doesn't exist" do
  #       subject { -> { get user_url 1 } }

  #       it { is_expected.to raise_error ActiveRecord::RecordNotFound }
  #     end
  #   end
  # end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_article_url
      expect(response.status).to eq 200
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
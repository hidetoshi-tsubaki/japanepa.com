require 'rails_helper'

RSpec.describe "Admin::QuizCategories", type: :request do
  let(:admin) { create(:admin) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, parent_id: section.id) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_quiz_categories_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display quiz_category titles" do
      get admin_quiz_categories_url
      expect(response.body).to include level.name
    end
  end

  describe "Get #new level" do
    it "has success to request" do
      get new_level_admin_quiz_categories_url, xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "Get #new category" do
    it "has success to request" do
      get new_level_admin_quiz_categories_url, xhr: :true
      expect(response).to have_http_status 200
    end
  end

  describe "Post #create category" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_quiz_categories_url, params: { quiz_category: attributes_for(:quiz_category) }, xhr: true
        expect(response).to have_http_status 200
      end

      it "has success to register quiz_category" do
        expect do
          post admin_quiz_categories_url, params: { quiz_category: attributes_for(:quiz_category) }, xhr: :true
        end.to change(QuizCategory, :count).by(1)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_quiz_categories_url, params: { quiz_category: attributes_for(:quiz_category, :invalid) }, xhr: true
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "failed to register quiz_category" do
        expect do
          post admin_quiz_categories_url, params: { quiz_category: attributes_for(:quiz_category, :invalid) }, xhr: :true
        end.not_to change(QuizCategory, :count)
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_quiz_category_url level, params: { quiz_category: attributes_for(:quiz_category, :update) }, format: :js
        expect(response).to have_http_status 200
      end

      it "has success to update quiz_category name" do
        expect do
          put admin_quiz_category_url level, params: { quiz_category: attributes_for(:quiz_category, :update) }, format: :js
        end.to change { QuizCategory.find(level.id).name }.from(level.name).to("updated")
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_quiz_category_url level, params: { quiz_category: attributes_for(:quiz_category, :update) }, format: :js
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect do
          put admin_quiz_category_url level, params: { quiz_category: attributes_for(:quiz_category, :update) }, format: :js
        end.not_to change { QuizCategory.find(level.id) }, :name
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_quiz_category_url level, format: :js
      expect(response).to have_http_status 200
    end

    it "when delete level category, related categories also will be deleted" do
      expect do
        delete admin_quiz_category_url level, format: :js
      end.to change(QuizCategory, :count).by(-3)
    end
  end
end

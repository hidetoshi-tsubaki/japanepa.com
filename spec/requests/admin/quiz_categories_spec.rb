require 'rails_helper'

RSpec.describe "Admin::QuizCategories", type: :request do
  let(:admin) { create(:admin) }
  let(:category_parent) { create(:category_parent) }
  let(:category_child) { create(:category_child, parent_id: category_parent.id ) }
  let(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }
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
      expect(response.body).to include "category_parent"
    end
  end

  describe "Get #new level" do it "has success to request" do
      get new_level_admin_quiz_categories_url, xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "Get #new category" do it "has success to request" do
      get new_level_admin_quiz_categories_url, xhr: :true
      expect(response).to have_http_status 200
    end
  end

    describe "Post #create category" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_quiz_categories_url, params: { quiz_category: (:category_parent) }, xhr: true
        expect(response).to have_http_status 200
      end

      it "has success to register quiz_category" do
        expect {
          post admin_quiz_categories_url, params: { quiz_category: attributes_for(:category_parent) }, xhr: :true
        }.to change(QuizCategory, :count).by(1)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_quiz_categories_url, params: { quiz_category: attributes_for(:category_parent, :invalid) }, xhr: true
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "failed to register quiz_category" do
        expect do
          post admin_quiz_categories_url, params: { quiz_category: attributes_for(:category_parent, :invalid) }, xhr: :true
        end.to_not change(QuizCategory, :count)
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_quiz_category_url category_parent, params: { quiz_category: attributes_for(:category_parent, :update) }, format: :js
        expect(response).to have_http_status 200
      end

      it "has success to update quiz_category name" do
        expect do
          put admin_quiz_category_url category_parent, params: { quiz_category: attributes_for(:category_parent, :update) }, format: :js
        end.to change { QuizCategory.find(category_parent.id).name }.from('category_parent').to("category_parent_A")
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_quiz_category_url category_parent, params: { quiz_category: attributes_for(:category_parent, :update) }, format: :js
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_quiz_category_url category_parent, params: { quiz_category: attributes_for(:category_parent, :update) }, format: :js
        }.to_not change{ QuizCategory.find(category_parent.id)}, :name
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_quiz_category_url category_parent, format: :js
      expect(response).to have_http_status 200
    end
    it "does not display deleted quiz_category" do
      delete admin_quiz_category_url category_parent, format: :js
      expect(response).to have_http_status 200
    end

    it "delete quiz category" do
      category_parent = create(:category_parent)
      expect {
        delete admin_quiz_category_url category_parent, format: :js
      }.to change(QuizCategory, :count).by(-1)
    end
  end
end
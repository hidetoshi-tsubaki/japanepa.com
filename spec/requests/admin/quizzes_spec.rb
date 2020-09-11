require 'rails_helper'

RSpec.describe "Admin::quizzes", type: :request do
  let(:admin) { create(:admin) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, parent_id: section.id) }
  let!(:quiz) { create(:quiz, category_id: title.id) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_quizzes_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display quiz titles" do
      create(:quiz, category_id: title.id)
      get admin_quizzes_url
      expect(response.body).to include
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_quiz_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    let(:quiz) { create :quiz, category_id: title.id }

    it "has success to request" do
      get edit_admin_quiz_url quiz
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display quiz question" do
      get edit_admin_quiz_url quiz
      expect(response.body).to include quiz.question
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, category_id: title.id) }
        expect(response).to have_http_status 302
      end

      it "has success to register quiz" do
        expect do
          post admin_quizzes_url, params: { quiz: attributes_for(:quiz, category_id: title.id) }
        end.to change(Quiz, :count).by(1)
      end

      it "redirect to admin  quizs index page" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, category_id: title.id) }
        expect(response).to redirect_to admin_quizzes_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response).to have_http_status 200
      end

      it "failed to register quiz" do
        expect do
          post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        end.not_to change(Quiz, :count)
      end

      it 'display error message' do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :update) }
        expect(response).to have_http_status 302
      end

      it "has success to update quiz name" do
        expect do
          put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :update) }
        end.to change { Quiz.find(quiz.id).question }.from(quiz.question).to("updated")
      end

      it "redirect to quizzes index page" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :update) }
        expect(response).to redirect_to(admin_quizzes_url)
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect do
          put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        end.not_to change { Quiz.find(quiz.id) }, :question
      end

      it "display error message" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_quiz_url quiz, format: :js
      expect(response).to have_http_status 302
    end

    it "delete quiz" do
      expect do
        delete admin_quiz_url quiz, format: :js
      end.to change(Quiz, :count).by(-1)
    end
  end
end

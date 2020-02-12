require 'rails_helper'

RSpec.describe "Admin::quizzes", type: :request do
  let(:admin) { create(:admin) }
  let(:category_parent) { create(:category_parent) }
  let(:category_child) { create(:category_child, parent_id: category_parent.id ) }
  let(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_quizzes_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display quiz titles" do
      create(:quiz, category_id: category_grandchild.id)
      get admin_quizzes_url
      expect(response.body).to include "question_1"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_quiz_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    let(:quiz){ create :quiz , category_id: category_grandchild.id }

    it "has success to request" do
      get edit_admin_quiz_url quiz
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display quiz question" do
      get edit_admin_quiz_url quiz
      expect(response.body).to include "question_1"
    end
  end

  describe "Post #create" do
    context "when paramater ris valid" do
      let!(:category_parent) { create(:category_parent) }
      let!(:category_child) { create(:category_child, parent_id: category_parent.id ) }
      let!(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }

      it "has success to request" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz) }
        expect(response).to have_http_status 302
      end

      it "has success to register quiz" do
        expect {
          post admin_quizzes_url, params: { quiz: attributes_for(:quiz) }
        }.to change(Quiz, :count).by(1)
      end

      it "redirect to admin  quizs index page" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz) }
        expect(response).to redirect_to admin_quizzes_url
      end
    end

    context "when paramater is invalid" do
      let!(:category_parent) { create(:category_parent) }
      let!(:category_child) { create(:category_child, parent_id: category_parent.id ) }
      let!(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }

      it "has success to request" do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response).to have_http_status 200
      end

      it "failed to register quiz" do
        expect do
          post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        end.to_not change(Quiz, :count)
      end

      it 'display error message' do
        post admin_quizzes_url, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    let!(:category_parent) { create(:category_parent) }
    let!(:category_child) { create(:category_child, parent_id: category_parent.id ) }
    let!(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }
    let!(:quiz){ create :quiz, category_id: category_grandchild.id }

    context "when paramater is valid" do
      it "has success to request" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz_A) }
        expect(response).to have_http_status 302
      end

      it "has success to update evet's name" do
        expect do
          put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz_A) }
        end.to change { Quiz.find(quiz.id).question }.from('question_1').to("カタカナ")
      end

      it "redirect to quizzes index page" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz_A) }
        expect(response).to redirect_to(admin_quizzes_url)
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        }.to_not change{ Quiz.find(quiz.id)}, :question
      end

      it "display error message" do
        put admin_quiz_url quiz, params: { quiz: attributes_for(:quiz, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:category_parent) { create(:category_parent) }
    let!(:category_child) { create(:category_child, parent_id: category_parent.id ) }
    let!(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }
    let!(:quiz){ create :quiz, category_id: category_grandchild.id }

    it "has success to request" do
      delete admin_quiz_url quiz, format: :js
      expect(response).to have_http_status 302
    end

    it "does not display deleted quiz" do
      delete admin_quiz_url quiz, format: :js
      expect(response).to have_http_status 302
    end

    it "delete quiz" do
      expect{
        delete admin_quiz_url quiz, format: :js
    }.to change(Quiz, :count).by(-1)
    end
  end
end
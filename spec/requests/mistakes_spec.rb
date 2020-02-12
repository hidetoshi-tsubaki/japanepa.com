require 'rails_helper'

RSpec.describe "Mistakes", type: :request do
  let(:user) { create(:user) }
  let(:category_parent) { create(:category_parent) }
  let(:category_child) { create(:category_child, parent_id: category_parent.id ) }
  let(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }
  let(:quiz) { create(:quiz, category_id: category_grandchild.id) }
  
  before do
    sign_in user
    mistake = create(:mistake, user_id: user.id, title_id: category_grandchild.id, quiz_id: quiz.id)
  end

  describe "GET #index" do
    it "has success to request" do
      get mistakes_url(id: category_grandchild)
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display mistaked question" do
      get mistakes_url(id: category_grandchild)
      expect(response.body).to include "question_2"
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete mistake_url Mistake.last, format: :js
      expect(response).to have_http_status 200
    end
    
    it "does not display deleted community" do
    delete mistake_url Mistake.last, format: :js
    expect(response).to have_http_status 200
  end
  
    it "delete community" do
      expect {
        delete mistake_url Mistake.last, format: :js
      }.to change(Mistake, :count).by(-1)
    end
  end
end
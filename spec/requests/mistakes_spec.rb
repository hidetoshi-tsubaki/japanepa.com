require 'rails_helper'

RSpec.describe "Mistakes", type: :request do
  let(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let!(:quiz) { create(:quiz, category_id: title.id) }
  let!(:mistak) { create(:mistake, user_id: user.id, title_id: title.id, quiz_id: quiz.id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get mistakes_url(id: title)
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display mistook question" do
      get mistakes_url(id: title)
      expect(response.body).to include quiz.question
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete mistake_url Mistake.last, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted community" do
      delete mistake_url Mistake.last, format: :js
      expect(response.body).not_to include quiz.question
    end

    it "delete community" do
      expect do
        delete mistake_url Mistake.last, format: :js
      end.to change(Mistake, :count).by(-1)
    end
  end
end

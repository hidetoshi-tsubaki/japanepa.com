require 'rails_helper'

RSpec.describe "QuizCategories", type: :request do
  let(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, parent_id: section.id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get quiz_categories_path
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display quiz level name" do
      get quiz_categories_path
      expect(response.body).to include level.name
    end
  end

  describe "GET #show" do
    it "has success to request" do
      get quiz_category_path level
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display quiz section and quiz title" do
      get quiz_category_path level
      expect(response.body).to include section.name
      expect(response.body).to include title.name
    end
  end
end

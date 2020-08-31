require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, parent_id: section.id) }
  let!(:review) { create(:review, user_id: user.id, title_id: title.id) }

  before do
    sign_in user
  end

  describe "Get #index" do
    it "has success to request" do
      get reviews_path
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display quiz title to review" do
      get reviews_path
      expect(response.body).to include title.name
    end
  end
end

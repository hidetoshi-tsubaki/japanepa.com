require 'rails_helper'

RSpec.describe "Admin::comments", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :comment_A
    end
  end
    it "has success to request" do
      get admin_comments_url
      expect(response.status).to eq(200)
    end

    it "display comment titles" do
      get admin_comments_url
      expect(response.body).to include "comment test_a"
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_comment_url community, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted community" do
      delete admin_comment_url community, format: :js
      expect(response).to have_http_status 200
    end

    it "delete community" do
      community = create(:community, :with_founder)
      expect {
        delete admin_community_url community, format: :js
      }.to change(Community, :count).by(-1)
    end
  end

end
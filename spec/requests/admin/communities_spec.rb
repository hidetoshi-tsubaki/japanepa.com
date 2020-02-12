require 'rails_helper'

RSpec.describe "Admin::Communities", type: :request do
  let(:admin) { create(:admin) }
  let(:community){ create(:community, :with_founder) }
  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_communities_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display community name" do
      community = create(:community, :with_founder)
      get admin_communities_url
      expect(response.body).to include "community_test"
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_community_url community, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted community" do
      delete admin_community_url community, format: :js
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
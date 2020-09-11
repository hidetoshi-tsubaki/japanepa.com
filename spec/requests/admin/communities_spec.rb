require 'rails_helper'

RSpec.describe "Admin::Communities", type: :request do
  let(:admin) { create(:admin) }
  let!(:community) { create(:community, :with_founder) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_communities_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display community name" do
      get admin_communities_url
      expect(response.body).to include community.name
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_community_url community, format: :js
      expect(response).to have_http_status 200
    end

    it "delete community" do
      community = create(:community, :with_founder)
      expect do
        delete admin_community_url community, format: :js
      end.to change(Community, :count).by(-1)
    end
  end
end

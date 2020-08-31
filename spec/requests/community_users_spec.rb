require 'rails_helper'

RSpec.describe "CommunityUsers", type: :request do
  let!(:user) { create(:user) }
  let!(:community) { create(:community, :with_founder) }

  before do
    sign_in user
  end

  describe "Post #create" do
    context "join community normally" do
      it "has success to request" do
        post community_users_url, params: { id: community.id }, xhr: true
        expect(response).to have_http_status 200
      end

      it "has success to join comunity" do
        expect do
          post community_users_url, params: { id: community.id }, xhr: true
        end.to change(CommunityUser, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:community_user) { create(:community_user, user_id: user.id, community_id: community.id) }

    it "has success to request" do
      delete community_user_url community, format: :js
      expect(response).to have_http_status 200
    end

    it "leave community" do
      expect do
        delete community_user_url community, format: :js
      end.to change(CommunityUser, :count).by(-1)
    end
  end
end

require 'rails_helper'

RSpec.describe "Communities", type: :request do
  let(:user) { create(:user) }
  let(:community) { create(:community, :with_founder) }
  let(:founder) { create(:founder) }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get communities_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display community name" do
      community = create(:community, :with_founder)
      get communities_url
      expect(response.body).to include "community_test"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_community_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_community_url community
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display community name" do
      get edit_community_url community
      expect(response.body).to include "community_test"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post communities_url, params: { community: attributes_for(:community, :with_founder_2) }
        expect(response).to have_http_status 302
      end

      it "has success to register community" do
        expect {
          post communities_url, params: { community: attributes_for(:community, :with_founder_2) }
        }.to change(Community, :count).by(1)
      end

      it "redirect to community index page" do
        post communities_url, params: { community: attributes_for(:community, :with_founder_2) }
        expect(response).to redirect_to community_url Community.last
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post communities_url, params: { community: attributes_for(:community, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "failed to register community" do
        expect do
          post communities_url, params: { community: attributes_for(:community, :invalid) }
        end.to_not change(Community, :count)
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put community_url community, params: { community: attributes_for(:community, :update) }
        expect(response).to have_http_status 302
      end

      it "has success to update community" do
        expect do
          put community_url community, params: { community: attributes_for(:community, :update) }
        end.to change { Community.find(community.id).name }.from('community_test').to('updated_community')
      end

      it "redirect to index page" do
        put community_url community, params: { community: attributes_for(:community, :update) }
        expect(response).to redirect_to(community_url community)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put community_url community, params: { community: attributes_for(:community, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put community_url community, params: { community: attributes_for(:community, :invalid) }
        }.to_not change{ Community.find(community.id)}, :name
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete community_url community
      expect(response).to have_http_status 302
    end

    it "does not display deleted community" do
      delete community_url community, xhr: true
      expect(response).to have_http_status 302
    end

    it "delete community" do
      community = create(:community)
      expect {
        delete community_url community
      }.to change(Community, :count).by(-1)
    end
  end
end
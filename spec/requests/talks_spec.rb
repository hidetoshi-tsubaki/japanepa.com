require 'rails_helper'

RSpec.describe "Talks", type: :request do
  let(:user) { create(:user) }
  let!(:community) { create(:community, :with_founder) }
  let!(:talk) { create(:talk, community_id: community.id) }

  before do
    sign_in user
  end

  describe "GET #feed" do
    it "has success to request" do
      get feed_talks_url
      expect(response.status).to eq(200)
    end

    it "display talk titles" do
      get feed_talks_url
      expect(response.body).to include talk.content
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_talk_url talk
      expect(response.status).to eq 200
    end

    it "display talk title" do
      get edit_talk_url talk
      expect(response.body).to include talk.content
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put talk_url talk, params: { talk: attributes_for(:talk, :update) }
        expect(response.status).to eq 302
      end

      it "has success to update talk content" do
        expect do
          put talk_url talk, params: { talk: attributes_for(:talk, :update) }
        end.to change { Talk.find(talk.id).content }.from(talk.content).to("updated")
      end

      it "redirect to index page" do
        put talk_url talk, params: { talk: attributes_for(:talk, :update) }
        expect(response).to redirect_to community_url(community, anchor: "talk_#{talk.id}")
      end
    end

    context "when paramater is invalid" do
      it "content does not be changed" do
        expect do
          put talk_url talk, params: { talk: attributes_for(:talk, :invalid) }
        end.not_to change { Talk.find(talk.id) }, :content
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete talk_url talk, format: :js
      expect(response.status).to eq 200
    end

    it "delete talk" do
      expect do
        delete talk_url talk, format: :js
      end.to change(Talk, :count).by(-1)
    end
  end
end

require 'rails_helper'

RSpec.describe "LikeTalks", type: :request do
  let!(:user) { create(:user) }
  let!(:talk) { create(:talk, :with_related_model, user_id: user.id) }

  before do
    sign_in user
  end

  describe "Post #create" do
    context "like talk normally" do
      it "has success to request" do
        post like_talks_url params: { id: talk.id }, format: :js
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "has success to like_talk" do
        post like_talks_url params: { id: talk.id }, format: :js
        expect(talk.like_talks.count).to eq 1
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      post like_talks_url params: { id: talk.id }, format: :js
    end

    it "has success to request" do
      delete like_talk_url talk, format: :js
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "delete like_talk" do
      expect(talk.like_talks.count).to eq 1
      delete like_talk_url talk, format: :js
      expect(talk.like_talks.count).to eq 0
    end
  end
end

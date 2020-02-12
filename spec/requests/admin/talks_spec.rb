require 'rails_helper'

RSpec.describe "Admin::Talks", type: :request do
  let(:admin) { create(:admin) }
  let(:talk){ create(:talk, :with_community) }
  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_talks_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display talk name" do
      talk = create(:talk, :with_community)
      get admin_talks_url
      expect(response.body).to include "talk test"
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_talk_url talk, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted talk" do
      delete admin_talk_url talk, format: :js
      expect(response).to have_http_status 200
    end

    it "delete talk" do
      talk = create(:talk, :with_community)
      expect {
        delete admin_talk_url talk, format: :js
      }.to change(Talk, :count).by(-1)
    end
  end
end
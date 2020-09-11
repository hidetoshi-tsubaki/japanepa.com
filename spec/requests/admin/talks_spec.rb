require 'rails_helper'

RSpec.describe "Admin::Talks", type: :request do
  let(:admin) { create(:admin) }
  let!(:talk) { create(:talk, :with_related_model) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_talks_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display talk name" do
      get admin_talks_url
      expect(response.body).to include talk.content
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_talk_url talk, format: :js
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "delete talk" do
      expect do
        delete admin_talk_url talk, format: :js
      end.to change(Talk, :count).by(-1)
    end
  end
end

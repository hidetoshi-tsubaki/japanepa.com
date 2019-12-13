require 'rails_helper'

RSpec.describe "Admin::Communities", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :community_A
      FactoryBot.create :community_B
    end
  end
    it "has success to request" do
      get admin_communities_url
      expect(response.status).to eq(200)
    end

    it "display community names" do
      get admin_communities_url
      expect(response).to include "community_a"
      expect(response).to include "community_b"
    end
  end
end

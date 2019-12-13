require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :taro
      FactoryBot.create :arjun
    end
  end
    it "has success to request" do
      get admin_users_url
      expect(response.status).to eq(200)
    end

    it "display user_name" do
      get admin_users_url
      expect(response).to include "taro"
      expect(response).to include "arjun"
    end
  end
end

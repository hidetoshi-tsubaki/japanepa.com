require 'rails_helper'

RSpec.describe "Admin::users", type: :request do
  let(:admin) { create(:admin) }
  let!(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_users_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display user name" do
      user = create(:user)
      get admin_users_url
      expect(response.body).to include user.name
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_user_url user
      expect(response).to have_http_status 302
    end

    it "delete user" do
      expect do
        delete admin_user_url user
      end.to change(User, :count).by(-1)
    end
  end
end

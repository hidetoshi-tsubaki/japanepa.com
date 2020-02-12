require 'rails_helper'

RSpec.describe "Admin::users", type: :request do
  let(:admin) { create(:admin) }
  let(:user){ create(:user) }
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
      expect(response.body).to include "test user"
    end
  end

  # describe "DELETE #destroy" do
  #   it "has success to request" do
  #     delete admin_user_url user, format: :js
  #     expect(response).to have_http_status 200
  #   end

  #   it "does not display deleted user" do
  #     delete admin_user_url user, format: :js
  #     expect(response).to have_http_status 200
  #   end

  #   it "delete user" do
  #     user = create(:user)
  #     expect {
  #       delete admin_user_url user, format: :js
  #     }.to change(User, :count).by(-1)
  #   end
  # end
end
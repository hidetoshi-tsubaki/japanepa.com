require 'rails_helper'

RSpec.describe "Admin::StaticPages", type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  before do
    sign_in admin
  end

  describe "Get #home" do
    context "when admin user log in" do
      it "has success to request" do
        get admin_url
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end
    end

    context "when user log in" do
      before do
        sign_out admin
        sign_in user
      end

      it "has not success to request" do
        get admin_url
        expect(response).not_to be_successful
        expect(response).to have_http_status 302
      end
    end

    context "when admin user doesn't log in" do
      before do
        sign_out admin
      end

      it "has not success to request" do
        get admin_url
        expect(response).not_to be_successful
        expect(response).to have_http_status 302
      end
    end
  end
end

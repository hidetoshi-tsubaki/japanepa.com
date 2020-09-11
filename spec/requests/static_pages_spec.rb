require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:user) { create(:user) }

  describe "Get #home" do
    context "when user signed in" do
      before do
        sign_in user
      end

      it "has success to request" do
        get root_url
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "display website title" do
        get root_url
        expect(response.body).to include user.name
        expect(response.body).to include "Home"
      end
    end

    context "when user didn't sign in" do
      it "has success to request" do
        get root_url
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "display website title" do
        get root_url
        expect(response.body).not_to include user.name
        expect(response.body).to include "Welcome to Japanepa.com"
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

    describe "Get #home" do
    it "has success to request" do
      get root_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display website title" do
      get root_url
      expect(response.body).to include "New Information"
    end
  end
end
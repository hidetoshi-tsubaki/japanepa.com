require 'rails_helper'

RSpec.describe "Admin::StaticPages", type: :request do
  let(:admin) { create(:admin) }
  before do
    sign_in admin
  end

    describe "Get #home" do
    it "has success to request" do
      get admin_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display website title" do
      get admin_url
      expect(response.body).to include "Japanepa.com"
    end
  end
end
require 'rails_helper'

RSpec.describe "Admin::Talks", type: :request do
  describe "GET /admin/talks" do
    it "works! (now write some real specs)" do
      get admin_talks_index_path
      expect(response).to have_http_status(200)
    end
  end
end

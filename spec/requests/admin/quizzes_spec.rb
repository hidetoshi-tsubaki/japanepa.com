require 'rails_helper'

RSpec.describe "Admin::Quizzes", type: :request do
  let!(:Quiz) { FactoryBot.create :quiz}
  describe "GET show" do
    it "works! (now write some real specs)" do
      get admin_quizzes_index_path
      expect(response).to have_http_status(200)
    end
  end
end

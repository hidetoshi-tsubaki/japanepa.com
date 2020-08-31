require 'rails_helper'

RSpec.describe "Announcement", type: :request do
  let(:user) { create(:user) }
  let!(:announce) { create :announcement }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get announcements_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display announcement titles" do
      get announcements_url
      expect(response.body).to include "announce"
    end
  end

  describe 'GET #show' do
    context 'when announcement exist' do
      subject { get announcement_url announce, format: :js }

      it { 'expect(response).to have_http_status 200' }

      it { "expect(response.body).to include 'this is announcement' " }
    end

    context 'when announcement does not exist' do
      subject { get announcement_url 1, format: :js }

      it { 'expect(response).to redirect_to announcements_path' }
    end
  end
end

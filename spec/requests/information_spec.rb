require 'rails_helper'

RSpec.describe "Admin::Information", type: :request do
  let(:user) { create(:user) }
  let(:info){ create (:information) }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get information_index_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display information titles" do
      get information_index_url
      expect(response.body).to include "info"
    end
  end

  describe 'GET #show' do
    context 'when infomation exist' do
      subject { get information_url info, format: :js }
      it { 'expect(response).to have_http_status 200' }

      subject { get information_url info, format: :js }
      it { "expect(response.body).to include 'this is information' " }
    end

    context 'when information does not exist' do
      subject { get information_url 1 , format: :js}
      it { 'expect(response).to redirect_to articles_path' }
    end
  end
end
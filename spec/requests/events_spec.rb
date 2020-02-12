require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
  let(:user) { create(:user) }
  let(:event){ create (:event) }
  before do
    sign_in user
  end

  describe 'GET #show' do
    context 'when event exist, request has to be success' do
        subject { get event_url event, format: :js }
        it { "expect(response).to have_http_status 200" }
    end

    context 'when event exist, it displays event title' do
      subject { get event_url event, format: :js }
      it { "expect(response).to include 'event detail' " }
    end

    context 'when event does not exist, it redirect to root_path' do
      subject { get event_url event, format: :js }
      it { 'expect(response).to redirect_to root_path' }
    end
  end
end
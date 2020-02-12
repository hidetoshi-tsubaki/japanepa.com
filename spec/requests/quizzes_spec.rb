require 'rails_helper'

RSpec.describe "Admin::Articles", type: :request do
  let(:user) { create(:user) }
  let(:article){ create (:article) }
  before do
    sign_in user
  end

  describe "GET #index" do
    it "has success to request" do
      get articles_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display article titles" do
      get articles_url
      expect(response.body).to include "japanese"
    end
  end

  describe 'GET #show' do
    context 'when article exist' do
      it 'has success to request' do
        get article_url article
        expect(response).to have_http_status 200
      end

      it 'display article title' do
        get article_url article
        expect(response.body).to include 'How to study Japanese'
      end
    end

    context 'when artcile does not exist' do
      subject { get article_url 1 }
      it { 'expect(response).to redirect_to articles_path' }
    end
  end
end
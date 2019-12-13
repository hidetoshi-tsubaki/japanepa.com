require 'rails_helper'

RSpec.describe "Articles", type: :request do
 describe "GET #index" do
    before do
      FactoryBot.create :taro
      FactoryBot.create :arjun
    end
  end
    it "has success to request" do
      get articles_url
      expect(response.status).to eq(200)
    end

    it "display article titles" do
      get article_url
      expect(response).to include "about_japan"
      expect(response).to include "about_nepal"
    end
  end

  describe "GET :show" do
    context "if user exist" do
      let(:taro) { FactoryBot.create :bout_japan }

      it "has success to request" do
        get article_url article1.id
        expect (response.status).to eq 200
      end

      it "display article title" do
        get article_url about_japan.id
        expect (response.body).to include "japan"
      end

      context "if user doesn't exist" do
        subject { -> { get user_url 1 } }
        it { is_expected.to raise_error ActiveRecord::RecordNotFound }
      end
    end
  end
end
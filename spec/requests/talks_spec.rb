require 'rails_helper'

RSpec.describe "Talks", type: :request do
  let(:user){ create(:user) }
  let(:community) { create(:community, :with_founder) }
    before do
      sign_in user
    end

  describe "GET #feed" do
  end
    it "has success to request" do
      get feed_url
      expect(response.status).to eq(200)
    end

    it "display talk titles" do
      get feed_url
      expect(response.body).to include "talk test"
    end
  end
  describe "GET #index" do
    before do
      FactoryBot.create :talk_A
    end
  end
    it "has success to request" do
      get admin_talks_url
      expect(response.status).to eq(200)
    end

    it "display talk titles" do
      get admin_talks_url
      expect(response.body).to include "talk test"
    end
  end

  describe "GET #edit" do
    let(:talk) { FactoryBot.create :talk }

    it "has success to request" do
      get edit_admin_talk_url talk
      expect(response.status).to eq 200
    end

    it "display talk title" do
      get edit_admin_talk_url talk
      expect(response.body).to include "talk test"
    end
  end


  describe "PUT #update" do
    let(:talk) { FactoryBot.create :talk }

    context "when paramater is valid" do
      it "has success to request" do
        put admin_talk_url talk, params: { talk: FactoryBot.attributes_for(:talk) }
        expect(response.status).to eq 302
      end

      it "has success to update talk title" do
        expect do
          put admin_talk_url talk, params: { talk: FactoryBot.attributes_for(:talk_A) }
        end.to change { talk.find(talk.id).title }.from('japanese').to("japan")
      end

      it "redirect to index page" do
        put admin_talk_url talk, params: { talk: FactoryBot.attributes_for(:talk_A) }
        expect(response).to redirect_to(admin_talks_url)
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        put admin_talk_url talk_A, params: { talk: FactoryBot.attributes_for(:talk, :invalid) }
        expect(response.status).to eq 200
      end

      it "name does not be changed" do
        expect do
        put admin_talk_url talk_A, params: { talk: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(talk.find(aticle_A.id)), :title
      end

      it "display error message" do
        put admin_talk_url, params: { talk: FactoryBot.attributes_for(:talk, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:talk) { FactoryBot.create :talk}

    it "has success to request" do
      delete admin_talk_url talk
      expect(response.status).to eq 302
    end

    it "does not display deleted talk" do
      delete admin_talk_url talk, xhr: true
      expect(response.status).to eq 200
    end

    it "delete community" do
      expect do
        delete admin_talk_url talk
      end.to change(talk, :count).by(-1)
    end

    it "redirect to index page" do
      delete admin_talk_url talk
      expect(body).to redirect_to admin_talks_url
    end

  end
end

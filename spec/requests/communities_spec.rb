require 'rails_helper'

RSpec.describe "Communities", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :community_A
      FactoryBot.create :community_B
    end
  end
    it "has success to request" do
      get communities_url
      expect(response.status).to eq(200)
    end

    it "display community names" do
      get communities_url
      expect(response).to include "community_a"
      expect(response).to include "community_b"
    end
  end

  describe "GET :show" do
    context "if community exist" do
      let(:community_a) { FactoryBot.create :community_a }

      it "has success to request" do
        get user_url community_a.id
        expect (response.status).to eq 200
      end

      it "display community_name" do
        get  community_url community_a.id
        expect (response.body).to include "community_test"
      end

      context "if community doesn't exist" do
        subject { -> { get community_url 1 } }

        it { is_expected.to raise_error ActiveRecord::RecordNotFound }
      end
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_community_url
      expect(response.status).to eq 200
    end
  end

  describe "GET #edit" do
    let(:community_A) { FactoryBot.create :community_A }

    it "has success to request" do
      get edit_community_url
      expect(response.status).to eq 200
    end

    it "display community title" do
      get edit_community_url community_A
      expect(respose.body).to include "japan"
    end

    it "display country" do
      get edit_admin_community_url community_A
      expect(response.body).to include "japan"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post communities_url, params: { community: FactoryBot.attributes_for(:community) }
        expect(response.status).to eq 302
      end

      it "has success to register community" do
        expect do
          post communities_url, params: { community: FactoryBot.attributes_for(:community) }
        end.to change(community, :count).by(1)
      end

      it "redirect to show page" do
        post communities_url, params: { aticle: FactoryBot.attributes_for(:community) }
        expect(response).to redirect_to Community.last
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post communities_url, params: { community: FactoryBot.attributes_for(:community :invalid) }
        expect(response.status).to eq 200
      end

      it "failed to register user" do
        expect do
          post admin_communities_url, params: { community: FactoryBot.attributes_for(:community :invalid) }
        end.to_not change(Community, :count)
      end

      it "display error massage"
      # formの一番上に入力が間違っています。　正確に入力してくださいを表示させる
      # それが表示されていたら登録失敗とする
    end
  end

  describe "PUT #update" do
    let(:community_A) { FactoryBot.create :community_A }

    context "when paramater is valid" do
      it "has success to request" do
        post community_url community_A, params: { community: FactoryBot.attributes_for(:cmmunity_B) }
        expect(response.status).to eq 302
      end

      it "has success to update community title" do
        expect do
          post community_url community_A, params: { community: FactoryBot.attributes_for(:community_B) }
        end.to change { community.find(community_A.id).title }.from('japan').to("nepal")
      end

      it "redirect to show page" do
        post community_url community_A, params: { community: FactoryBot.attributes_for(:community_B) }
        expect(response).to redirect_to community_A
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        patch community_url community_A, params: { community: FactoryBot.attributes_for(:community, :invalid) }
        expect(response.status).to eq 200
      end

      it "name does not be changed" do
        expect do
        patch community_url community_A, params: { community: FactoryBot.attributes_for(:community, :invalid) }
        end.to_not change(community.find(community_A.id)), :name
      end

      it "display error message" do

      end
    end
  end

  describe "DELETE #destroy" do
    let!(:community) { FactoryBot.create :community}

    it "has success to request" do
      delete community_url community
      expect(response.status).to eq 302
    end

    it "delete community" do
      expect do
        delete community_url community
      end.to change(community, :count).by(-1)
    end

    it "should redirect to index page" do
      delete community_url community
      expect(response).to redirect_to(communities_url)
    end
  end
end
require 'rails_helper'

RSpec.describe "Users", type: :request do
 describe "GET #index" do
    before do
      FactoryBot.create :taro
      FactoryBot.create :arjun
    end
  end
    it "has success to request" do
      get users_url
      expect(response.status).to eq(200)
    end

    it "display user_name" do
      get users_url
      expect(response).to include "taro"
      expect(response).to include "arjun"
    end
  end

  describe "GET :show" do
    context "if user exist" do
      let(:taro) { FactoryBot.create :taro }

      it "has success to request" do
        get user_url taro.id
        expect (response.status).to eq 200
      end

      it "display user_name" do
        get  user_url taro.id
        expect (response.body).to include "taro"
      end

      context "if user doesn't exist" do
        subject { -> { get user_url 1 } }

        it { is_expected.to raise_error ActiveRecord::RecordNotFound }
      end
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_user_registration_url
      expect(response.status).to eq 200
    end
  end

  describe "GET #edit" do
    let(:taro) { FactoryBot.create :taro }

    it "has success to request" do
      get edit_user_url taro
      expect(response.status).to eq 200
    end

    it "display user_name" do
      get edit_user_url taro
      expect(respose.body).to include "taro"
    end

    it "display country" do
      get edit_user_url taro
      expect(response.body).to include "JP"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post user_registration_url, params: { user: FactoryBot.attributes_for(:user) }
        expect(response.status).to eq 302
      end

      it "has success to register user" do
        expect do
          post user_registratioi_url, params: { user: FactoryBot.attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it "redirect to root" do
        post user_registratioi_url, params: { user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to User.last
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post user_registratioi_url, params: { user: FactoryBot.attributes_for(:user :invalid) }
        expect(response.status).to eq 200
      end

      it "failed to register user" do
        expect do
          post user_registratioi_url, params: { user: FactoryBot.attributes_for(:user :invalid) }
        end.to_not change(User, :count)
      end

      it "display"
      # formの一番上に入力が間違っています。　正確に入力してくださいを表示させる
      # それが表示されていたら登録失敗とする
    end
  end

  describe "PUT #update" do
    let(:taro) { FactoryBot.create :taro }

    context "when paramater is valid" do
      it "has success to request" do
        patch user_registration_url taro, params: { user: FactoryBot.attributes_for(:arjan) }
        expect(response.status).to eq 302
      end

      it "has success to update user_name" do
        expect do
          patch user_registration_url taro, params: { user: FactoryBot.attributes_for(:arjun) }
        end.to change { User.find(taro.id).name }.from('taro').to("arjan")
      end

      it "redirect to show page" do
        patch user_registration_url taro, params: { user: FactoryBot.attributes_for(:arjan) }
        expect(response).to ridirect_to User.last
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        patch user_registration_url taro, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it "name does not be changed" do
        expect do
        patch user_registration_url taro, params: { user: FactoryBot.attributes_for(:user, :invalid) }
        end.to_not change(User.find(taro.id)), :name
      end

      it "display error message" do

      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { FactoryBot.create :user }

    it "has success to request" do
      delete user_registration_url
      expect(response.status).to eq 302
    end

    it "delete user" do
      expect do
        delete user_registration_url user
      end.to change(User, :count).by(-1)
    end

    it "redirect to index page" do
      delete user_registration_url user
      expect(response).to redirect_to(users_url)
    end
  end
end
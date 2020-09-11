require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, :with_related_model) }

  before do
    sign_in user
    create_list(:level, 10)
  end

  describe "GET #index(Ranking)" do
    it "has success to request" do
      get ranking_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display user_name" do
      get ranking_url
      expect(response.body).to include user.name
      expect(response.body).to include "Ranking"
    end
  end

  describe "GET :show" do
    context "if user exist" do
      it "has success to request" do
        get user_url user.id
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "display user_name" do
        get user_url user.id
        expect(response.body).to include user.name
      end

      context "if user doesn't exist" do
        subject { -> { get user_url 1 } }

        it { 'expect(response).to redirect_to root_url' }
      end
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_user_registration_url
      expect(response).to have_http_status 302
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_user_registration_url user
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display user_name" do
      get edit_user_registration_url user
      expect(response.body).to include user.name
    end
  end

  describe "Post #create" do
    before do
      sign_out user
    end

    context "when paramater is valid" do
      it "has success to request" do
        post user_registration_url, params: { user: attributes_for(:user) }
        expect(response).to have_http_status 302
      end

      it "has success to register user" do
        expect do
          post user_registration_url, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it "redirect to root" do
        post user_registration_url, params: { user: attributes_for(:user) }
        expect(response).to redirect_to root_path
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post user_registration_url, params: { user: attributes_for(:user, :invalid) }
        expect(response.status).to eq 200
      end

      it "failed to register user" do
        expect do
          post user_registration_url, params: { user: attributes_for(:user, :invalid) }
        end.not_to change(User, :count)
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }

    context "when paramater is valid" do
      it "has success to request" do
        put user_registration_url user, params: { user: attributes_for(:user, :update) }
        expect(response).to have_http_status 302
      end

      it "has success to update user_name" do
        expect do
          put user_registration_url user, params: { user: attributes_for(:user, :update) }
        end.to change { User.find(user.id).name }.from(user.name).to("updated user")
      end

      it "redirect to show page" do
        put user_registration_url user, params: { user: attributes_for(:user, :update) }
        expect(response.body).to redirect_to user_path user
      end
    end

    context "when paramater is invalid" do
      let(:user) { create(:user) }

      it " has success to request" do
        put user_registration_url user, params: { user: attributes_for(:user, :invalid) }
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect do
          put user_registration_url user, params: { user: attributes_for(:user, :invalid) }
        end.not_to change { User.find(user.id) }, :name
      end

      it "display error message" do
        put user_registration_url user, params: { user: attributes_for(:user, :invalid) }
        expect(response.body).to include 'Please input correct values'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete user_registration_url
      expect(response.status).to eq 302
    end

    it "delete user" do
      expect do
        delete user_registration_url
      end.to change(User, :count).by(-1)
    end

    it "redirect to index page" do
      delete user_registration_url
      expect(response).to redirect_to root_path
    end
  end
end

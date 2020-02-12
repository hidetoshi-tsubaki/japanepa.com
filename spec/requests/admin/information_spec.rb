require 'rails_helper'

RSpec.describe "Admin::Information", type: :request do
  let(:admin) { create(:admin) }
  let(:information){ create :information }
  before do
    sign_in admin
  end
  describe "GET #index" do

    it "has success to request" do
      get admin_informations_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display information name" do
      information = create(:information)
      get admin_informations_url
      expect(response.body).to include "new information"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_information_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    let(:information){ create :information }

    it "has success to request" do
      get edit_admin_information_url information
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display information title" do
      get edit_admin_information_url information
      expect(response.body).to include "new information"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_informations_url, params: { information: attributes_for(:information) }
        expect(response).to have_http_status 302
      end

      it "has success to register information" do
        expect {
          post admin_informations_url, params: { information: attributes_for(:information) }
        }.to change(information, :count).by(1)
      end

      it "redirect to information index page" do
          post admin_informations_url, params: { information: attributes_for(:information) }
          expect(response).to redirect_to admin_informations_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_informations_url, params: { information: attributes_for(:information, :invalid) }
        expect(response).to have_http_status 200
      end

      it "failed to register information" do
        expect do
          post admin_informations_url, params: { information: attributes_for(:information, :invalid) }
        end.to_not change(information, :count)
      end

      it 'display error message' do
        post admin_informations_url, params: { information: attributes_for(:information, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_information_url information, params: { information: attributes_for(:information_A) }
        expect(response).to have_http_status 302
      end

      it "has success to update information name" do
        expect do
          put admin_information_url information, params: { information: attributes_for(:information_A) }
        end.to change { information.find(information.id).name }.from('new information').to("information_a")
      end

      it "redirect to index page" do
        put admin_information_url information, params: { information: attributes_for(:information_A) }
        expect(response).to redirect_to(admin_informations_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_information_url information, params: { information: attributes_for(:information, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_information_url information, params: { information: attributes_for(:information, :invalid) }
        }.to_not change{ information.find(information.id) }, :name
      end

      it "display error message" do
        put admin_information_url information, params: { information: attributes_for(:information, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_information_url information, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted information" do
      delete admin_information_url information, format: :js
      expect(response).to have_http_status 200
    end

    it "delete information" do
      information =  create(:information)
      expect {
        delete admin_information_url information, format: :js
      }.to change(information, :count).by(-1)
    end
  end
end
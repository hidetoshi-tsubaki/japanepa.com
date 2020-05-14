require 'rails_helper'

RSpec.describe "Admin::Announcement", type: :request do
  let!(:admin) { create(:admin) }
  let!(:announcement) { create :announcement }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_announcements_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display announcement name" do
      get admin_announcements_url
      expect(response.body).to include "new announcement"
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_announcement_url
      expect(response).to be_success
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_admin_announcement_url announcement
      expect(response).to be_success
      expect(response).to have_http_status 200
    end

    it "display announcement title" do
      get edit_admin_announcement_url announcement
      expect(response.body).to include "new announcement"
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_announcements_url, params: { announcement: attributes_for(:announcement) }
        expect(response).to have_http_status 302
      end

      it "has success to register announcement" do
        expect {
          post admin_announcements_url, params: { announcement: attributes_for(:announcement) }
        }.to change(announcement, :count).by(1)
      end

      it "redirect to announcement index page" do
          post admin_announcements_url, params: { announcement: attributes_for(:announcement) }
          expect(response).to redirect_to admin_announcements_url
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post admin_announcements_url, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response).to have_http_status 200
      end

      it "failed to register announcement" do
        expect do
          post admin_announcements_url, params: { announcement: attributes_for(:announcement, :invalid) }
        end.to_not change(announcement, :count)
      end

      it 'display error message' do
        post admin_announcements_url, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "PUT #update" do
    context "when paramater is valid" do
      it "has success to request" do
        put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement_A) }
        expect(response).to have_http_status 302
      end

      it "has success to update announcement name" do
        expect do
          put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement_A) }
        end.to change { announcement.find(announcement.id).name }.from('new announcement').to("announcement_a")
      end

      it "redirect to index page" do
        put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement_A) }
        expect(response).to redirect_to(admin_announcements_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response).to be_success
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect {
          put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement, :invalid) }
        }.to_not change{ announcement.find(announcement.id) }, :name
      end

      it "display error message" do
        put admin_announcement_url announcement, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_announcement_url announcement, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted announcement" do
      delete admin_announcement_url announcement, format: :js
      expect(response).to have_http_status 200
    end

    it "delete announcement" do
      announcement = create(:announcement)
      expect {
        delete admin_announcement_url announcement, format: :js
      }.to change(announcement, :count).by(-1)
    end
  end
end
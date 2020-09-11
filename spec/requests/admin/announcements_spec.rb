require 'rails_helper'

RSpec.describe "Admin::Announcement", type: :request do
  let!(:admin) { create(:admin) }
  let!(:announce1) { create :announcement }
  let!(:announce2) { create :announcement }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_announcements_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display announcement name" do
      get admin_announcements_url
      expect(response.body).to include announce1.title
      expect(response.body).to include announce2.title
    end
  end

  describe "Get #new" do
    it "has success to request" do
      get new_admin_announcement_url
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end
  end

  describe "GET #edit" do
    it "has success to request" do
      get edit_admin_announcement_url announce1
      expect(response).to be_successful
      expect(response).to have_http_status 200
    end

    it "display announcement title" do
      get edit_admin_announcement_url announce1
      expect(response.body).to include announce1.title
    end
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post admin_announcements_url, params: { announcement: attributes_for(:announcement) }
        expect(response).to have_http_status 302
      end

      it "has success to register announcement" do
        expect do
          post admin_announcements_url, params: { announcement: attributes_for(:announcement) }
        end.to change(Announcement, :count).by(1)
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
        end.not_to change(Announcement, :count)
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
        put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :update) }
        expect(response).to have_http_status 302
      end

      it "has success to update announcement name" do
        expect do
          put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :update) }
        end.to change { Announcement.find(announce1.id).title }.from(announce1.title).to("updated")
      end

      it "redirect to index page" do
        put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :update) }
        expect(response).to redirect_to(admin_announcements_url)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response).to be_successful
        expect(response).to have_http_status 200
      end

      it "name does not be changed" do
        expect do
          put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :invalid) }
        end.not_to change { Announcement.find(announce1.id) }, :title
      end

      it "display error message" do
        put admin_announcement_url announce1, params: { announcement: attributes_for(:announcement, :invalid) }
        expect(response.body).to include '入力値が正しくありません'
      end
    end
  end

  describe "DELETE #delete" do
    it "has success to request" do
      delete admin_announcement_url announce1, format: :js
      expect(response).to have_http_status 200
    end

    it "delete announcement" do
      expect do
        delete admin_announcement_url announce1, format: :js
      end.to change(Announcement, :count).by(-1)
    end
  end
end

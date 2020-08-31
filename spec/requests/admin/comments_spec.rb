require 'rails_helper'

RSpec.describe "Admin::comments", type: :request do
  let(:admin) { create(:admin) }
  let!(:comment) { create(:comment) }
  let!(:comment_2) { create(:comment) }

  before do
    sign_in admin
  end

  describe "GET #index" do
    it "has success to request" do
      get admin_comments_url
      expect(response).to be_successful
      expect(response.status).to eq 200
    end

    it "display comment contents" do
      get admin_comments_url
      expect(response.body).to include comment.contents
    end
  end

  describe "Get #show" do
    it "has success to request" do
      get admin_comment_url comment
      expect(response.status).to eq 200
    end

    it "display comment content" do
      get admin_comment_url comment
      expect(response.body).to include comment.contents
      expect(response.body).not_to include comment_2.contents
    end
  end

  describe "DELETE #destroy" do
    it "has success to request" do
      delete admin_comment_url comment, format: :js
      expect(response).to have_http_status 200
    end

    it "delete community" do
      expect do
        delete admin_comment_url comment, format: :js
      end.to change(Comment, :count).by(-1)
    end
  end
end

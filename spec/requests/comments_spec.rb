RSpec.describe "Admin::comments", type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create :comment
    end

    it "has success to request" do
      get admin_comments_url, xhr: true
      expect(response.status).to eq(200)
    end

    it "display article titles" do
      get admin_articles_url, xhr: true
      expect(response.body).to include "japan"
    end
  end
  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        put comment_url, params: { comment: FactoryBot.attributes_for(:comment) }, xhr: true
        expect(response.status).to eq 302
      end

      it "has success to register comment" do
        expect do
          put comments_url, params: { comment: FactoryBot.attributes_for(:comment) }, xhr: true
        end.to change(comment, :count).by(1)
      end

      it "redirect to comment index page" do
        put comments_url, params: { aticle: FactoryBot.attributes_for(:comment) }, xhr: true
        expect(body) has_content "comment test"
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        put comments_url, params: { comment: FactoryBot.attributes_for(:comment :invalid) }, xhr: true
        expect(response.status).to eq 200
      end

      it "failed to register comment" do
        expect do
          put comments_url, params: { comment: FactoryBot.attributes_for(:comment :invalid) }, xhr: true
        end.to_not change(comment, :count)
      end

  end

  describe "PUT #update" do
    let(:comment) { FactoryBot.create :comment }

    context "when paramater is valid" do
      it "has success to request" do
        put comment_url comment, params: { comment: FactoryBot.attributes_for(:comment) }, xhr: true
        expect(response.status).to eq 302
      end

      it "has success to update comment title" do
        expect do
          put comment_url comment, params: { comment: FactoryBot.attributes_for(:comment_A) }, xhr: true
        end.to change { comment.find(comment.id).content }.from('comment test').to("comment test_a")
      end
    end

    context "when paramater is invalid" do
      it " has success to request" do
        put comment_url comment, params: { comment: FactoryBot.attributes_for(:comment, :invalid) }, xhr: true
        expect(response.status).to eq 200
      end

      it "content does not be changed" do
        expect do
        put admin_comment_url comment, params: { comment: FactoryBot.attributes_for(:user, :invalid) }, xhr: true
        end.to_not change(comment.find(comment.id).), :content
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { FactoryBot.create :comment}

    it "has success to request" do
      delete comment_url comment, xhr: true
      expect(response.status).to eq 302
    end

    it "does not display deleted comment" do
      delete admin_comment_url comment, xhr: true
      expect(response.status).to eq 200
    end

    it "delete community" do
      expect do
        delete comment_url comment, xhr: true
      end.to change(comment, :count).by(-1)
    end

    it "doesn't display deleted comment" do
      delete comment_url comment, xhr: true
      expect(page).not_to have_content 'comment test'
    end
  end
end
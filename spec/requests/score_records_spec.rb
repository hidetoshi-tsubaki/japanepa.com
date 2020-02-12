require 'rails_helper'

RSpec.describe "ScoreRecords", type: :request do
  let(:category_parent) { create(:category_parent) }
  let(:category_child) { create(:category_child, parent_id: category_parent.id ) }
  let(:category_grandchild) { create(:category_grandchild, parent_id: category_child.id) }
  let(:quiz) { create(:quiz, category_id: category_grandchild.id) }

  
  before do
    user = create(:user)
    sign_in user
    create_list(:level, 10)
  end

  describe "Post #create" do
    context "when paramater is valid" do
      it "has success to request" do
        post score_records_url, xhr: true, params: { score_record: attributes_for(:score_record, title_id: category_grandchild.id) }
        expect(response).to have_http_status 302
      end

      it "has success to register community" do
        expect {
          post score_records_url, xhr: true, params: { score_record: attributes_for(:score_record, title_id: category_grandchild.id) }
        }.to change(ScoreRecord, :count).by(1)
      end
    end

    context "when paramater is invalid" do
      it "has success to request" do
        post score_records_url, params: { score_record: attributes_for(:score_record, :invalid) }
        expect(response).to be_success
        expect(json).to 
      end

      it "failed to register community" do
        expect do
          post score_records_url, params: { score_record: attributes_for(:score_record, :invalid) }
        end.to_not change(Community, :count)
      end
    end
  end



  describe "GET show" do
    it "has success to request" do
      get score_record_url category_grandchild, format: :js
      expect(response).to have_http_status 200
    end

    it "does not display deleted community" do
      get score_record_url category_grandchild, format: :js
      expect(response).to have_http_status 200
    end

    it "return json" do
      get score_record_url category_grandchild, format: :js
      expect(json[0]).to "score_record"
    end
  end
end



# score recordのパラメーターを再現
# Parameters: {"`score_record"=>{"score"=>"66", "title_id"=>"17", "mistake_ids"=>["5"], "correct_ids"=>["5", "13"]}}
# experienceが0出ないこと
# jsonを返すこと
#  score recordが増えているか


# Create


# show 
# json　を返すこと
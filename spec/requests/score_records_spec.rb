require 'rails_helper'

RSpec.describe "ScoreRecords", type: :request do
  let!(:user) { create(:user, :with_related_model) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let!(:quiz) { create(:quiz, category_id: title.id) }
  let(:learning_level) { build(:learning_level) }

  before do
    sign_in user
    create_list(:level, 30)
  end

  describe "Post #create" do
    subject { post score_records_url, xhr: true, params: { score_record: attributes_for(:score_record, title_id: title.id) } }

    context "when paramater is valid" do
      describe "when create score_record, related model will be created" do
        it { "expect(response).to have_http_status 200" }
        
        it { "expect(Learninglevel.count).to eq 1" }
        
        it { "expect(Master.count).to eq 1" }
        
        it { "expect(ScoreRecord.count).to eq 1" }
      end
    end

    context "when paramater is invalid" do
      describe "has success to request" do
        it { "expect(response).to have_http_status 200" }
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ScoreRecord, type: :model do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let(:score_record) { build(:score_record, user_id: user.id, title_id: title.id) }

  it "is valid with score, user_id, title_id" do
    expect(score_record).to be_valid
  end

  it "is invalid without score" do
    score_record.score = nil
    score_record.valid?
    expect(score_record.errors[:score]).to include "can't be blank"
  end

  it "is invalid without user_id" do
    score_record.user_id = nil
    score_record.valid?
    expect(score_record.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without title_id" do
    score_record.title_id = nil
    score_record.valid?
    expect(score_record.errors[:title_id]).to include "can't be blank"
  end
end

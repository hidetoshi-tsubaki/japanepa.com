require 'rails_helper'

RSpec.describe ScoreRecord, type: :model do
  before(:each) do
    @user = create(:user)
    @quiz_category = create(:quiz_category)
    @score_record = ScoreRecord.new(
      score: "100",
      user_id: @user.id,
      title_id: @quiz_category.id
    )
  end

  it "is valid with score, user_id, title_id" do
    expect(@score_record).to be_valid
  end

  it "is invalid without score" do
    @score_record.score = nil
    expect(@score_record).not_to be_valid
  end

  it "is invalid without user_id" do
    @score_record.user_id = nil
    expect(@score_record).not_to be_valid
  end

  it "is invalid without title_id" do
    @score_record.title_id = nil
    expect(@score_record).not_to be_valid
  end
end

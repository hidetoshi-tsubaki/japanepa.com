require 'rails_helper'

RSpec.describe Mistake, type: :model do
  before do
    @user = create(:user)
    @category = create(:quiz_category)
    @quiz = create(:quiz, category_id: @category.id)
    @mistake = Mistake.new(
      user_id: @user.id,
      quiz_id: @quiz.id,
      title_id: @category.id
      )
  end

  it "is valid with user_id, quiz_id and title_id" do
    expect(@mistake).to be_valid
  end

  it "is invalid without user_id" do
    @mistake.user_id = nil
    expect(@mistake).not_to be_valid
  end

  it "is invalid without quiz_id" do
    @mistake.quiz_id = nil
    expect(@mistake).not_to be_valid
  end

  it "is invalid without title_id" do
    @mistake.title_id = nil
    expect(@mistake).not_to be_valid
  end

  describe "when Mistake already exists" do
    it "is invalid with same user_id, quiz_id and title_id" do
      mistake1 = create(:mistake)
      mistake2 = create(:mistake)
      expect(mistake2).not_to be_valid
    end
  end
end

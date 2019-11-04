require 'rails_helper'

RSpec.describe Quiz, type: :model do
  before(:each) do
    @quiz_category = create(:quiz_category)
    @quiz = build(:quiz, category_id: @quiz_category.id)
  end
  it "is valid with question, questioin_html, choice1, choice2, choice3, choice4, category_id" do
    expect(@quiz).to be_valid
  end

  it "is invalid without question" do
    @quiz.question = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without question_html" do
    @quiz.question_html = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without choice1" do
    @quiz.choice1 = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without choice2" do
    @quiz.choice2 = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without choice3" do
    @quiz.choice3 = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without choice4" do
    @quiz.choice4 = nil
    expect(@quiz).not_to be_valid
  end

  it "is invalid without category_id" do
    @quiz.category_id = nil
    expect(@quiz).not_to be_valid
  end
  describe "when question_html is already exists" do
    it "is invalid with same question_html" do
      quiz1 = create(:quiz)
      quiz2 = build(:quiz)
      expect(quiz2).not_to be_valid
    end
  end

end

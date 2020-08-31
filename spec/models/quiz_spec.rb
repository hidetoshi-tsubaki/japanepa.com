require 'rails_helper'
RSpec.describe Quiz, type: :model do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let(:quiz) { build(:quiz, category_id: title.id) }

  it "is valid with question, questioin_html, choice1, choice2, choice3, choice4, category_id" do
    expect(quiz).to be_valid
  end

  it "is invalid without question" do
    quiz.question = nil
    quiz.valid?
    expect(quiz.errors[:question]).to include "can't be blank"
  end

  it "is invalid without question_html" do
    quiz.question_html = nil
    quiz.valid?
    expect(quiz.errors[:question_html]).to include "can't be blank"
  end

  it "is invalid without choice1" do
    quiz.choice1 = nil
    quiz.valid?
    expect(quiz.errors[:choice1]).to include "can't be blank"
  end

  it "is invalid without choice2" do
    quiz.choice2 = nil
    quiz.valid?
    expect(quiz.errors[:choice2]).to include "can't be blank"
  end

  it "is invalid without choice3" do
    quiz.choice3 = nil
    quiz.valid?
    expect(quiz.errors[:choice3]).to include "can't be blank"
  end

  it "is invalid without choice4" do
    quiz.choice4 = nil
    quiz.valid?
    expect(quiz.errors[:choice4]).to include "can't be blank"
  end

  it "is invalid without category_id" do
    quiz.category_id = nil
    quiz.valid?
    expect(quiz.errors[:category_id]).to include "can't be blank"
  end
end

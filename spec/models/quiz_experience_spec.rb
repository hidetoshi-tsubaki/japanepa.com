require 'rails_helper'

RSpec.describe QuizExperience, type: :model do
  before(:each) do
    @quiz_category = create(:quiz_category)
    @quiz_experience = QuizExperience.new(
      title_id: @quiz_category.id,
      experience: "40"
    )
  end

  it "is valid with title_id and experience" do
    expect(@quiz_experience).to be_valid
  end

  it "is invalid without title_id" do
    @quiz_experience.title_id = nil
    expect(@quiz_experience).not_to be_valid
  end

  it "is invalid without experience" do
    @quiz_experience.experience = nil
    expect(@quiz_experience).not_to be_valid
  end
  describe "when quiz_experience already exists" do
    it "is invalid with same title_id" do
      quiz_experience1 = create(:quiz_experience)
      quiz_experience2 = build(:quiz_experience)
      expect(quiz_experience2).not_to be_valid
    end
  end
end

require 'rails_helper'

RSpec.describe QuizExperience, type: :model do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:seciton) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, parent_id: seciton.id) }
  let!(:quiz_experience) { create(:quiz_experience, title_id: title.id) }

  it "is valid with title_id and experience" do
    expect(quiz_experience).to be_valid
  end

  it "is invalid without title_id" do
    quiz_experience.title_id = nil
    quiz_experience.valid?
    expect(quiz_experience.errors[:title_id]).to include "can't be blank"
  end

  context "when quiz_experience already exists" do
    it "is invalid with same title_id" do
      quiz_experience2 = build(:quiz_experience, title_id: title.id)
      quiz_experience2.valid?
      expect(quiz_experience2.errors[:title_id]).to include "has already been taken"
    end
  end
end

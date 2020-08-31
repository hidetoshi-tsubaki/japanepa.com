require 'rails_helper'
RSpec.describe Mistake, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let!(:quiz) { create(:quiz, category_id: title.id) }
  let(:mistake) { build(:mistake, user_id: user.id, title_id: title.id, quiz_id: quiz.id) }
  let!(:existing_mistake) { create(:mistake, user_id: user2.id, title_id: title.id, quiz_id: quiz.id) }

  it "is valid with user_id, quiz_id and title_id" do
    expect(mistake).to be_valid
  end

  it "is invalid without user_id" do
    mistake.user_id = nil
    mistake.valid?
    expect(mistake.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without quiz_id" do
    mistake.quiz_id = nil
    mistake.valid?
    expect(mistake.errors[:quiz_id]).to include "can't be blank"
  end

  it "is invalid without title_id" do
    mistake.title_id = nil
    mistake.valid?
    expect(mistake.errors[:title_id]).to include "can't be blank"
  end

  context "when Mistake already exists" do
    it "is invalid with same user_id, quiz_id and title_id" do
      mistake2 = build(:mistake, user_id: user2.id, title_id: title.id, quiz_id: quiz.id)
      mistake2.valid?
      expect(mistake2.errors[:user_id]).to include "has already been taken"
    end
  end
end

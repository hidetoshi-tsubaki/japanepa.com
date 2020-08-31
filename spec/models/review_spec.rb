require 'rails_helper'

RSpec.describe Review, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let(:quiz) { build(:quiz, category_id: title.id) }
  let(:review) { build(:review, user_id: user.id, title_id: level.id) }
  let!(:existing_review) { create(:review, user_id: user2.id, title_id: level.id) }

  it "is valid with title_id and user_id" do
    expect(review).to be_valid
  end

  it "is invalid without user_id" do
    review.user_id = nil
    review.valid?
    expect(review.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without title_id" do
    review.title_id = nil
    review.valid?
    expect(review.errors[:title_id]).to include "can't be blank"
  end

  context "when review already exists" do
    it "is invalid with same user_id and title_id" do
      review2 = build(:review, user_id: user2.id, title_id: level.id)
      review2.valid?
      expect(review2.errors[:user_id]).to include "has already been taken"
    end
  end
end

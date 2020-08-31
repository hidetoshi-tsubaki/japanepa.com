require 'rails_helper'
RSpec.describe LearningLevel, type: :model do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let(:learning_level) { build(:learning_level) }

  it "is valid with user_id, title_id and percentage" do
    expect(learning_level).to be_valid
  end

  it "is invalid without user_id" do
    learning_level.user_id = nil
    learning_level.valid?
    expect(learning_level.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without title_id" do
    learning_level.title_id = nil
    learning_level.valid?
    expect(learning_level.errors[:title_id]).to include "can't be blank"
  end

  context "when learning level has aleardy exists" do
    let!(:existing_learning_level) { create(:learning_level) }

    it "is invalid with same user_id and title_id" do
      learning_level.valid?
      expect(learning_level.errors[:user_id]).to include "has already been taken"
    end
  end
end

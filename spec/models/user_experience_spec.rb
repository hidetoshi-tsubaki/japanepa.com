require 'rails_helper'
RSpec.describe UserExperience, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let(:user_experience) { build(:user_experience, user_id: user.id) }
  let!(:existing_user_experience) { create(:user_experience, user_id: user2.id) }

  it "is valid with user_id and total_experience" do
    expect(user_experience).to be_valid
  end

  it "is invalid without user_id" do
    user_experience.user_id = nil
    user_experience.valid?
    expect(user_experience.errors[:user_id]).to include "can't be blank"
  end

  context "when user_experience already exists" do
    it "is invalid with same user_id" do
      user_experience2 = build(:user_experience, user_id: user2.id)
      user_experience2.valid?
      expect(user_experience2.errors[:user_id]).to include "has already been taken"
    end
  end
end

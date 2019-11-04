require 'rails_helper'

RSpec.describe UserTotalExperience, type: :model do
  before(:each) do
    @user = create(:user)
    @user_total_experience = UserTotalExperience.new(user_id: @user.id)
  end

  it "is valid with user_id and total_experience" do
    expect(@user_total_experience).to be_valid
  end

  it "is invalid without user_id" do
    @user_total_experience.user_id = nil
    expect(@user_total_experience).not_to be_valid
  end

  describe "when user_total_experience is already token" do
    it "is invalid with same user_id" do
      user_total_experience1 = create(:user_total_experience)
      user_total_experience2 = build(:user_total_experience)
      expect(user_total_experience2).not_to be_valid
    end
  end
end

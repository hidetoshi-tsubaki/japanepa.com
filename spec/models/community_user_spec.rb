require 'rails_helper'

RSpec.describe CommunityUser, type: :model do
  before do
    @user = create(:user)
    @community = create(:community)
    @community_user = CommunityUser.new(
      user_id: @user.id,
      community_id: @community.id
      )
  end

  it "is valid with user_id and community_id" do
    expect(@community_user).to be_valid
  end

  it "is invalid without user_id" do
    @community_user.user_id = nil
    expect(@community_user).not_to be_valid
  end

  it "is invalid without community_id" do
    @community_user.community_id = nil
    expect(@community_user).not_to be_valid
  end

  describe "when communityUser already exists" do
    it "is invalid with same user_id and community_id" do
      community_user1 = create(:community_user)
      community_user2 = build(:community_user)
      expect(community_user2).not_to be_valid
    end
  end
end

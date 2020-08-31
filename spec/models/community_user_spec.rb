require 'rails_helper'
RSpec.describe CommunityUser, type: :model do
  let!(:user) { create(:user) }
  let!(:community) { create(:community, :with_founder) }
  let!(:community_user) { build(:community_user, :with_related_model) }
  let!(:existing_community_user) { create(:community_user, user_id: user.id, community_id: community.id) }

  it "is valid with user_id and community_id" do
    expect(community_user).to be_valid
  end

  it "is invalid without user_id" do
    community_user.user_id = nil
    community_user.valid?
    expect(community_user.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without community_id" do
    community_user.community_id = nil
    community_user.valid?
    expect(community_user.errors[:community_id]).to include "can't be blank"
  end

  context "when communityUser already exists" do
    it "is invalid with same user_id and community_id" do
      community_user2 = build(:community_user, user_id: user.id, community_id: community.id)
      community_user2.valid?
      expect(community_user2.errors[:user_id]).to include "has already been taken"
    end
  end
end

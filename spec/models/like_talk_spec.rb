require 'rails_helper'

RSpec.describe LikeTalk, type: :model do
  before do
    @user = create(:user)
    @community = create(:community)
    @talk = create(:talk)
    @like_talk = LikeTalk.new(
      user_id: @user.id,
      talk_id: @talk.id
    )
  end

  it "is valid with user_id and talk_id" do
    expect(@like_talk).to be_valid
  end

  it "is invalid without user_id" do
    @like_talk.user_id = nil
    expect(@like_talk).not_to be_valid
  end

  it "is invalid without talk_id" do
    @like_talk.talk_id = nil
    expect(@like_talk).not_to be_valid
  end

  describe "when LikeTalk already exists" do
    it "is invalid with same user_id and talk_id" do
      like_talk1 = create(:like_talk)
      like_talk2 = build(:like_talk)
      expect(like_talk2).not_to be_valid
    end
  end
end
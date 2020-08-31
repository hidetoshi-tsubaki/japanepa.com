require 'rails_helper'

RSpec.describe LikeTalk, type: :model do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:talk) { create(:talk, :with_related_model) }
  let!(:like_talk) { build(:like_talk, user_id: user.id, talk_id: talk.id) }
  let!(:existing_like_talk) { create(:like_talk, user_id: user2.id, talk_id: talk.id) }

  it "is valid with user_id and talk_id" do
    expect(like_talk).to be_valid
  end

  it "is invalid without user_id" do
    like_talk.user_id = nil
    like_talk.valid?
    expect(like_talk.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without talk_id" do
    like_talk.talk_id = nil
    like_talk.valid?
    expect(like_talk.errors[:talk_id]).to include "can't be blank"
  end

  context "when Liketalk already exists" do
    it "is invalid with same user_id and talk_id" do
      like_talk2 = build(:like_talk, user_id: user2.id, talk_id: talk.id)
      like_talk2.valid?
      expect(like_talk2.errors[:user_id]).to include "has already been taken"
    end
  end
end

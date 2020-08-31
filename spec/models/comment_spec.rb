require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { build(:comment) }

  it "is valid with user_id, talk_id, contents" do
    expect(comment).to be_valid
  end

  it "is invalid without user_id" do
    comment.user_id = nil
    comment.valid?
    expect(comment.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without talk_id" do
    comment.talk_id = nil
    comment.valid?
    expect(comment.errors[:talk_id]).to include "can't be blank"
  end

  it "is invalid without contents" do
    comment.contents = nil
    comment.valid?
    expect(comment.errors[:contents]).to include "can't be blank"
  end

  it "is invalid with length of contents, more than 300" do
    comment.contents = "a" * 301
    comment.valid?
    expect(comment.errors[:contents]).to include "is too long (maximum is 300 characters)"
  end
end

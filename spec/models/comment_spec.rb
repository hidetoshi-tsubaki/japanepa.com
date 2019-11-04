require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = create(:user)
    @communty = create(:community)
    @talk = create(:talk)
    @comment = Comment.new(user_id: @user.id, talk_id: @talk.id, contents: "contents_test")
  end

  it "is valid with user_id, talk_id, contents" do
    expect(@comment).to be_valid
  end

  it "is invalid without user_id" do
    @comment.user_id = nil
    expect(@comment).not_to be_valid
  end

  it "is invalid without talk_id" do
    @comment.talk_id = nil
    expect(@comment).not_to be_valid
  end

  it "is invalid without contents" do
    @comment.contents = nil
    expect(@comment).not_to be_valid
  end

  it "is invalid with length of contents, more than 300" do
    @comment.contents = "a" * 301
    expect(@comment).not_to be_valid
  end
end

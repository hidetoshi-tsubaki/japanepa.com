require 'rails_helper'

RSpec.describe UserExperience, type: :model do
  before do
    @user = User.create(
      name: "test",
      password: "password",
      password_confirmation: "password"
    )
    @user_experience = UserExperience.create(
      user_id: @user.id
    )
  end

  it "is valid with user_id and total_experience" do
    expect(@user_experience).to be_valid
  end

  it "is invalid without user_id" do
    @user_experience.user_id = nil
    @user_experience.valid?
    expect(@user_experience.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid with same user_id" do
    user_experience2 = UserExperience.create(
      user_id: @user.id
    )
    user_experience2.valid?
    expect(user_experience2.errors[:user_id]).to include "has already been taken"
  end
end

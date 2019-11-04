require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = build(:user)
  end

  it "is valid with name, password and password_confirmation" do
    expect(@user).to be_valid
  end

  it "is invalid without name" do
    @user.name = nil
    expect(@user).not_to be_valid
  end

  it "is invalid without password" do
    @user.password = nil
    expect(@user).not_to be_valid
  end

  it "is invalid without password_confirmation" do
    @user.password_confirmation = nil
    expect(@user).not_to be_valid
  end

  describe "when user name is already token" do
    it "is invalid with same name" do
      user1 = create(:user)
      user2 = build(:user)
      expect(user2).not_to be_valid
    end
  end
end

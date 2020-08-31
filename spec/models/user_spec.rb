require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build(:user) }
  let!(:existing_user) { create(:user, name: "existed user") }

  it "is valid with name, password and password_confirmation" do
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include "can't be blank"
  end

  it "is invalid without password" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include "can't be blank"
  end

  context "when user name is already token" do
    it "is invalid with same name" do
      user2 = build(:user, name: "existed user")
      user2.valid?
      expect(user2.errors[:name]).to include "has already been taken"
    end
  end
end

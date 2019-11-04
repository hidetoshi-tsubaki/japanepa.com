require 'rails_helper'

RSpec.describe Admin, type: :model do
  before(:each) do
    @admin = build(:admin)
  end
  it "is valid with email and password" do
    expect(@admin).to be_valid
  end

  it "is invalid without email" do
    @admin.email = nil
    expect(@admin).not_to be_valid
  end

  it "is invalid without password" do
    @admin.password = nil
    expect(@admin).not_to be_valid
  end
end

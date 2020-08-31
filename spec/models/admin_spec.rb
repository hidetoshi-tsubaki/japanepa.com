require 'rails_helper'
RSpec.describe Admin, type: :model do
  let(:admin) { build(:admin) }

  it "is valid with name and password" do
    expect(admin).to be_valid
  end

  it "is invalid without name" do
    admin.name = nil
    admin.valid?
    expect(admin.errors[:name]).to include "can't be blank"
  end

  it "is invalid without password" do
    admin.password = nil
    admin.valid?
    expect(admin.errors[:password]).to include "can't be blank"
  end
end

require 'rails_helper'

RSpec.describe Level, type: :model do
  it "is valid with threshold" do
    level = build(:level)
    expect(level).to be_valid
  end

  it "is invalid without threshold" do
    level = build(:level, threshold: nil)
    expect(level).not_to be_valid
  end
end

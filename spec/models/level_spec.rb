require 'rails_helper'
RSpec.describe Level, type: :model do
  let(:level) { build(:level) }

  it "is valid with threshold" do
    expect(level).to be_valid
  end

  it "is invalid without threshold" do
    level.threshold = nil
    level.valid?
    expect(level.errors[:threshold]).to include "can't be blank"
  end
end

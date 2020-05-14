require 'rails_helper'

RSpec.describe Announcement, type: :model do
  before do
    @announce = build(:announcement)
  end

  it "is valid with title, contents, status" do
    expect(@announce).to be_valid
  end

  it "is invalid without title" do
    @announce.name = nil
    expect(@announce).not_to be_valid
  end

  it "is invalid with title, more than 41" do
    @announce.title = nil
    expect(@announce).not_to be_valid
  end

  it "is invalid without contents" do
    @announce.contents = nil
    expect(@announce).not_to be_valid
  end

  it "is invalid without status" do
    @announce.status = nil
    expect(@announce).not_to be_valid
  end

end

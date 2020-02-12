require 'rails_helper'

RSpec.describe Information, type: :model do
  before(:each) do
    @information = build(:information)
  end

  it "is valid with title, contents, status" do
    expect(@information).to be_valid
  end

  it "is invalid without title" do
    @information.name = nil
    expect(@information).not_to be_valid
  end

  it "is invalid with title, more than 41" do
    @inforamtion.title = nil
    expect(@information).not_to be_valid
  end

  it "is invalid without contents" do
    @information.contents = nil
    expect(@information).not_to be_valid
  end

  it "is invalid without status" do
    @information.status = nil
    expect(@information).not_to be_valid
  end

end

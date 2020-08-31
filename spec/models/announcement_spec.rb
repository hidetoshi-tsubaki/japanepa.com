require 'rails_helper'

RSpec.describe Announcement, type: :model do
  let(:announce) { build(:announcement) }

  it "is valid with title, contents, status" do
    expect(announce).to be_valid
  end

  it "is invalid without title" do
    announce.title = nil
    announce.valid?
    expect(announce.errors[:title]).to include "can't be blank"
  end

  it "is invalid with title, more than 40" do
    announce.title = "a" * 41
    announce.valid?
    expect(announce.errors[:title]).to include "is too long (maximum is 40 characters)"
  end

  it "is invalid with title, less than 2" do
    announce.title = "a" * 1
    announce.valid?
    expect(announce.errors[:title]).to include "is too short (minimum is 2 characters)"
  end

  it "is invalid without contents" do
    announce.contents = nil
    announce.valid?
    expect(announce.errors[:contents]).to include "can't be blank"
  end

  it "is invalid with contents, more than 200000" do
    announce.contents = "a" * 200001
    announce.valid?
    expect(announce.errors[:contents]).to include "is too long (maximum is 200000 characters)"
  end

  it "is invalid without status" do
    announce.status = nil
    announce.valid?
    expect(announce.errors[:status]).to include "can't be blank"
  end
end

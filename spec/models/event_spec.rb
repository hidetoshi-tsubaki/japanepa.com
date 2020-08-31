require 'rails_helper'
RSpec.describe Event, type: :model do
  let(:event) { build(:event) }

  it "is valid with name, detail, status" do
    expect(event).to be_valid
  end

  it "is invalid without name" do
    event.name = nil
    event.valid?
    expect(event.errors[:name]).to include "can't be blank"
  end

  it "is invalid with name ,more than 9 letters" do
    event.name = "a" * 10
    event.valid?
    expect(event.errors[:name]).to include "is too long (maximum is 9 characters)"
  end

  it "is invalid with name, less than 1 letter" do
    event.name = "a"
    event.valid?
    expect(event.errors[:name]).to include "is too short (minimum is 2 characters)"
  end

  it "is invalid without detail" do
    event.detail = nil
    event.valid?
    expect(event.errors[:detail]).to include "can't be blank"
  end

  it "is invalid with detail ,more than 200000 letters" do
    event.detail = "a" * 200001
    event.valid?
    expect(event.errors[:detail]).to include "is too long (maximum is 200000 characters)"
  end

  it "is invalid with detail less than 2 letter" do
    event.detail = "a"
    event.valid?
    expect(event.errors[:detail]).to include "is too short (minimum is 2 characters)"
  end

  it "is invalid without status" do
    event.status = nil
    event.valid?
    expect(event.errors[:status]).to include "can't be blank"
  end
end

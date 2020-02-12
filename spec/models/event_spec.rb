require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:each) do
    @event = build(:event)
  end

  it "is valid with title, detail, status" do
    expect(@event).to be_valid
  end

  it "is invalid without title" do
    @event.title = nil
    expect(@event).not_to be_valid
  end

  it "is invalid with title, less than 1 letter" do
    @event.title = "a"
    expect(@event).not_to be_valid
  end

  it "is invalid with title ,more than 10 letters" do
    @event.title = "a" * 10
    expect(@event).not_to be_valid
  end

  it "is invalid without detail" do
    @event.detail = nil
    expect(@event).not_to be_valid
  end

  it "is invalid without status" do
    @event.status = nil
    expect(@event).not_to be_valid
  end

end

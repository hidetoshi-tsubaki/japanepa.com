require 'rails_helper'

RSpec.describe QuizCategory, type: :model do
  before(:each) do
    @quiz_category = build(:quiz_category)
  end

  it "is valid with name" do
    expect(@quiz_category).to be_valid
  end

  it "is invalid without name" do
    @quiz_category.name = nil
    expect(@quiz_category).not_to be_valid
  end
end

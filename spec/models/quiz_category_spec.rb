require 'rails_helper'

RSpec.describe QuizCategory, type: :model do
  let!(:user) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }

  it "is valid with name" do
    expect(title).to be_valid
  end

  it "is invalid without name" do
    title.name = nil
    title.valid?
    expect(title.errors[:name]).to include "can't be blank"
  end
end

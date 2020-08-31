require 'rails_helper'
RSpec.describe Master, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:level) { create(:quiz_category) }
  let!(:section) { create(:section, parent_id: level.id) }
  let!(:title) { create(:title, :with_related_model, parent_id: section.id) }
  let(:master) { build(:master, user_id: user.id, title_id: title.id) }
  let!(:existing_master) { create(:master, user_id: user2.id, title_id: title.id) }

  it "is valid with user_id and title_id" do
    expect(master).to be_valid
  end

  it "is invalid without user_id" do
    master.user_id = nil
    master.valid?
    expect(master.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without title_id" do
    master.title_id = nil
    master.valid?
    expect(master.errors[:title_id]).to include "can't be blank"
  end

  context "when master already exists" do
    it "is invalid with same user_id and title_id" do
      master2 = build(:master, user_id: user2.id, title_id: title.id)
      master2.valid?
      expect(master2.errors[:user_id]).to include "has already been taken"
    end
  end
end

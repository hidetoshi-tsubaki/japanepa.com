require 'rails_helper'
RSpec.describe Community, type: :model do
  let(:community) { build(:community, :with_founder) }
  let!(:existing_community) { create(:community, :with_founder, name: "community") }

  it "is valid with name, introduction and founder_id" do
    expect(community).to be_valid
  end

  it "is invalid without name" do
    community.name = nil
    community.valid?
    expect(community.errors[:name]).to include "can't be blank"
  end

  it "is invalid without introduction" do
    community.introduction = nil
    community.valid?
    expect(community.errors[:introduction]).to include "can't be blank"
  end

  it "is invalid without founder_id" do
    community.founder_id = nil
    community.valid?
    expect(community.errors[:founder]).to include "must exist"
  end

  context "upload img exept specified extension" do
    it "is invalid without specified extension" do
      community.img.purge
      community.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      community.valid?
      expect(community.errors[:img]).to include "you can upload only png, jpg and jpeg"
    end
  end

  context "when community name is already token" do
    it "is invalid with same name" do
      community2 = build(:community, :with_founder, name: "community")
      community2.valid?
      expect(community2.errors[:name]).to include "has already been taken"
    end
  end
end

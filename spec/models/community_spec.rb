require 'rails_helper'

RSpec.describe Community, type: :model do
  before do
    @founder = create(:user)
    @community = Community.new(
      name: "test",
      introduction: "introduction_test",
      founder_id: @founder.id
      )
    @community.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'q1.png')), filename: 'q1.png', content_type: 'image/png')
  end
  it "is valid with name, introduction and founder_id" do
    expect(@community).to be_valid
  end

  it "is invalid without name" do
    @community.name = nil
    expect(@community).not_to be_valid
  end

  it "is invalid without introduction" do
    @community.introduction = nil
    expect(@community).not_to be_valid
  end

  it "is invalid without founder_id" do
    @community.founder_id = nil
    expect(@community).not_to be_valid
  end

  it "is invalid without img" do
    @community.img.purge
    expect(@community).not_to be_valid
  end

  describe "upload img exept specified extension" do
    it "is invalid without specified extension" do
      @community.img.purge
      @community.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      expect(@community).not_to be_valid
    end
  end

  describe "when community name is already token" do
    it "is invalid with same name" do
      community1 = create(:community)
      community2 = build(:community)
      expect(community2).not_to be_valid
    end
  end
end

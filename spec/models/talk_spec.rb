require 'rails_helper'

RSpec.describe Talk, type: :model do
  before(:each) do
    @user = create(:user)
    @community = create(:community)
    @talk = Talk.new(
      community_id: @community.id,
      user_id: @user.id,
      content: "content_test"
    )
  end

  it "is valid with content, user_id, community_id" do
    expect(@talk).to be_valid
  end

  it "is invalid without content" do
    @talk.content = nil
    expect(@talk).not_to be_valid
  end

  it "is invalid without user_id" do
    @talk.user_id = nil
    expect(@talk).not_to be_valid
  end

  it "is invalid without comunity_id" do
    @talk.community_id = nil
    expect(@talk).not_to be_valid
  end

  describe "upload img exept specified extension" do
    it "is invalid without specified extension" do
      @talk.img.purge
      @talk.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      expect(@talk).not_to be_valid
    end
  end

end

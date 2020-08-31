require 'rails_helper'

RSpec.describe Talk, type: :model do
  let(:talk) { build(:talk, :with_related_model) }

  it "is valid with content, user_id, community_id" do
    expect(talk).to be_valid
  end

  it "is invalid without content" do
    talk.content = nil
    talk.valid?
    expect(talk.errors[:content]).to include "can't be blank"
  end

  it "is invalid with letters more than 801" do
    talk.content = "a" * 801
    talk.valid?
    expect(talk.errors[:content]).to include "is too long (maximum is 800 characters)"
  end

  it "is invalid without user_id" do
    talk.user_id = nil
    talk.valid?
    expect(talk.errors[:user_id]).to include "can't be blank"
  end

  it "is invalid without comunity_id" do
    talk.community_id = nil
    talk.valid?
    expect(talk.errors[:community_id]).to include "can't be blank"
  end

  describe "upload img exept specified extension" do
    it "is invalid without specified extension" do
      talk.img.purge
      talk.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      expect(talk).not_to be_valid
    end
  end
end

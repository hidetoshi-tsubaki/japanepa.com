require 'rails_helper'
RSpec.describe Article, type: :model do
  let(:article) { build(:article) }

  it "is valid with title, contents, lead, img" do
    expect(article).to be_valid
  end

  it "is invalid without title" do
    article.title = nil
    article.valid?
    expect(article.errors[:title]).to include "can't be blank"
  end

  it "is invalid with title, more than 100 words" do
    article.title = "a" * 101
    article.valid?
    expect(article.errors[:title]).to include "is too long (maximum is 100 characters)"
  end

  it "is invalid without lead" do
    article.lead = nil
    article.valid?
    expect(article.errors[:lead]).to include "can't be blank"
  end

  it "is invalid with lead, more than 240 words" do
    article.lead = "a" * 241
    article.valid?
    expect(article.errors[:lead]).to include "is too long (maximum is 240 characters)"
  end

  it "is invalid without contents" do
    article.contents = nil
    article.valid?
    expect(article.errors[:contents]).to include "can't be blank"
  end

  it "is invalid with content, more than 200000 words" do
    article.contents = "a" * 200001
    article.valid?
    expect(article.errors[:contents]).to include "is too long (maximum is 200000 characters)"
  end

  it "is invalid without img" do
    article.img.purge
    article.valid?
    expect(article.errors[:img]).to include "must upload image"
  end

  it "is invalid without status" do
    article.status = nil
    article.valid?
    expect(article.errors[:status]).to include "can't be blank"
  end

  context "when upload img exept specified extension" do
    it "is invalid without specified extension" do
      article.img.purge
      article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      article.valid?
      expect(article.errors[:img]).to include "you can upload only png, jpg and jpeg"
    end
  end
end

require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @article = build(:article)
  end

  it "is valid with title, contents, lead, img" do
    expect(@article).to be_valid
  end

  it "is invalid without title" do
    @article.title = nil
    expect(@article).not_to be_valid
  end

  it "is invalid without contents" do
    @article.contents = nil
    expect(@article).not_to be_valid
  end

  it "is invalid without lead" do
    @article.lead = nil
    expect(@article).not_to be_valid
  end

  it "is invalid without img" do
    @article.img.purge
    expect(@article).not_to be_valid
  end

  it "is invalid without status" do
    @artile,status = nil
    expect(@article).not_to be_valid
  end

  describe "upload img exept specified extension" do
    it "is invalid without specified extension" do
      @article.img.purge
      @article.img.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'text_extension.rtf')), filename: 'text_extentioin')
      expect(@article).not_to be_valid
    end
  end

end

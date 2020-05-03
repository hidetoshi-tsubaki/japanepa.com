require 'rails_helper'

RSpec.describe Counting, type: :model do
  let(:counting) { build(:counting) }

  it "is valid with users, quiz_play, article_views, communities and talks" do
    expect(counting).to be_valid
  end

  it "is invalid without users" do
    counting.users = nil
    counting.valid?
    expect(counting.errors[:users]).to include "can't be blank"
  end

  it "is invalid without quiz_play" do
    counting.quiz_play = nil
    counting.valid?
    expect(counting.errors[:quiz_play]).to include "can't be blank"
  end

  it "is invalid without article_views" do
    counting.article_views = nil
    counting.valid?
    expect(counting.errors[:article_views]).to include "can't be blank"
  end

  it "is invalid without communities" do
    counting.communities = nil
    counting.valid?
    expect(counting.errors[:communities]).to include "can't be blank"
  end

  it "is invalid without talks" do
    counting.talks = nil
    counting.valid?
    expect(counting.errors[:talks]).to include "can't be blank"
  end

  context "when counting was created at same day" do
    let!(:existing_counting) { create(:counting) }

    it "is invalid at same day" do
      counting.valid?
      expect(counting.errors[:create_at]).to include "can't create another counting at same day"
    end
  end
end

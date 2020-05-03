class Counting < ApplicationRecord
  validates :users, :quiz_play, :article_views, :communities, :talks, presence: true
  validate :can_not_duplicate_date

  def can_not_duplicate_date
    if Counting.exists?(created_at: Time.zone.now.all_day)
      errors.add(:create_at, "can't create another counting at same day")
    end
  end
end

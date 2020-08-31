class Level < ApplicationRecord
  validates :threshold, presence: true

  scope :now, -> (user) do
    where("threshold <= ?", user.user_experience.total_point).
      order(threshold: :desc).limit(1).pluck(:id).first
  end

  scope :next_threshold, -> (num) do
    where("id > ?", num).order("id ASC").first.threshold
  end
end

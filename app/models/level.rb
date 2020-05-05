class Level < ApplicationRecord
  validates :threshold, presence: true

  scope :get_current_level, -> {
    order(threshold: :desc).
    limit(1).
    pluck(:id).
    first
  }
end

class Level < ApplicationRecord
  validates :threshold, presence: true
end

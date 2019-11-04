class UserTotalExperience < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :user_id, uniqueness: true
end

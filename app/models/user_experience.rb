class UserExperience < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :user_id, uniqueness: true

  scope :current_experience, -> (user) do
    find_by(user_id: user.id).total_point
  end
end

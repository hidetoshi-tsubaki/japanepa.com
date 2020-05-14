class AnnouncementCheck < ApplicationRecord
  belongs_to :user
  belongs_to :announcement

  validates :user_id, :announcement_id, presence: true
  validates :user_id, uniqueness: { scope: :announcement_id }
end

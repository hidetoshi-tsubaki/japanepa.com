class InformationCheck < ApplicationRecord
  belongs_to :user
  belongs_to :information

  validates :user_id, :information_id, presence: true
  validates :user_id, uniqueness: { scope: :information_id }
end

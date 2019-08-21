class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community
  validates :user_id, :community_id, presence: true
  validates :user_id, :uniqueness => { :scope => :community_id }
end

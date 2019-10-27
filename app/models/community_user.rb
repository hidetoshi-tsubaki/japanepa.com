class CommunityUser < ApplicationRecord
  belongs_to :user
  belongs_to :community
  counter_culture :user, column_name: 'community_count'
  counter_culture :community, column_name: 'member_count'
  validates :user_id, :community_id, presence: true
  validates :user_id, :uniqueness => { :scope => :community_id }
end

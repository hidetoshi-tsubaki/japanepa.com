class Talk < ApplicationRecord
  belongs_to :user
  counter_culture :user, column_name: 'talk_count'
  belongs_to :community
  counter_culture :community, column_name: 'talk_count'
  has_many :comments, dependent: :destroy
  has_many :like_talks, dependent: :destroy
  has_many :users, through: :like_talks
  has_one_attached :img
  validates :content, uniqueness: { case_sensitive: false }
  validates :community_id, presence: true
end

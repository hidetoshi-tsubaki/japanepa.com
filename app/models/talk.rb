class Talk < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :like_talks, dependent: :destroy
  has_many :users, through: :like_talks
  has_one_attached :img
  belongs_to :user
  counter_culture :user, column_name: 'talk_count'
  belongs_to :community
  counter_culture :community, column_name: 'talk_count'

  validates :content, :user_id, :community_id, presence: true
  validate :image_content_type
end

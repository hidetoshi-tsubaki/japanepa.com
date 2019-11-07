class LikeTalk < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  counter_culture :talk, column_name: 'likes_count'
  validates :user_id, :talk_id, presence: true
  validates :user_id, :uniqueness => { :scope => :talk_id }
end

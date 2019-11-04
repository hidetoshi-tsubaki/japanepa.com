class LikeTalk < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  validates :user_id, :talk_id, presence: true
  validates :user_id, :uniqueness => { :scope => :talk_id }
end

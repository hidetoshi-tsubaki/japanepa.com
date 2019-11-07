class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  counter_culture :talk
  validates :user_id, :talk_id, :contents, presence: true
  validates :contents, length: { in: 1..300 }
end

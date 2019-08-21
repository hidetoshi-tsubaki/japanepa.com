class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  validates :user_id, :talk_id, :contents, presence: true
end

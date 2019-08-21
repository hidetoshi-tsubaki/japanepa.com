class ScoreRecord < ApplicationRecord
  belongs_to :user
  validates :score, :quizTitle, :user_id, presence: true
end

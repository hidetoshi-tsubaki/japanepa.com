class ScoreRecord < ApplicationRecord
  belongs_to :user
  counter_culture :user, column_name: 'play_count'
  validates :score, :user_id, :title_id, presence: true
  validates :user_id, :uniqueness => { :scope => :title_id }

end
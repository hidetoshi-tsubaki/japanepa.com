class Mistake < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  belongs_to :category, foreign_key: "title_id", class_name: 'QuizCategory'
  validates :user_id, :quiz_id, :title_id, :count, presence: true
  validates :user_id, :uniqueness => { scope: [:quiz_id, :title_id] }

end


class Mistake < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  belongs_to :category, foreign_key: "title_id", class_name: 'QuizCategory'
  validates :quiz_id, uniqueness: true
end

class QuizExperience < ApplicationRecord
  belongs_to :category, foreign_key: 'title_id', class_name: 'QuizCategory'
  validates :title_id, :rate, presence: true
  validates :title_id, uniqueness: true
end

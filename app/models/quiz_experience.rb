class QuizExperience < ApplicationRecord
  belongs_to :category, foreign_key: 'title_id', class_name: 'QuizCategory'
end

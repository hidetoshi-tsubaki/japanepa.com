class Quiz < ApplicationRecord
  validates :question, :choice1, :choice2, :choice3, :choice4, presence: true
  belongs_to :category, class_name: 'QuizCategory', foreign_key: "category_id"
end

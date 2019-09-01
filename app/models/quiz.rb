class Quiz < ApplicationRecord
  validates :question, :choice1, :choice2, :choice3, :choice4, :category_id presence: true
  belongs_to :category, class_name: 'QuizCategory', foreign_key: "category_id"

  scope :get_quizzes_in, ->(title) { where("category_id = ?", title )}
end

class Quiz < ApplicationRecord
  validates :question, :question_html, :choice1, :choice2, :choice3, :choice4, :category_id, presence: true
  has_many :mistakes
  belongs_to :category, class_name: 'QuizCategory', foreign_key: "category_id"

  scope :get_quizzes_in, ->(title) { where("category_id = ?", title )}
end
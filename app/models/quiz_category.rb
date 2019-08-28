class QuizCategory < ApplicationRecord
  acts_as_nested_set
  has_many :quizzes, foreign_key: "category_id"

  scope :sections_in, ->(level) { level.children }
  scope :titles_in, ->(section) {section.children}

  def all_quizzes
    scope = Quiz.joins(:category)
    scope.where(quiz_category: { id: self_and_descendants.select(:id) })
  end
end
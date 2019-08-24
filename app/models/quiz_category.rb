class QuizCategory < ApplicationRecord
  acts_as_nested_set
  has_many :quizzes, foreign_key: "category_id"

  def all_products
    scope = Quiz.join(:category)
    scope.where(quiz_category: { id: self_and_descendants.select(:id) })
  end
end

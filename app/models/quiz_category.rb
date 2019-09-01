class QuizCategory < ApplicationRecord
  has_many :quizzes, foreign_key: "category_id"
  has_many :categories, -> { order(position: :asc) },foreign_key: 'parent_id', class_name: 'QuizCategory'
  belongs_to :parent, foreign_key: "parent_id", optional: true
  acts_as_list scope: :parent_id
  acts_as_nested_set

  scope :levels, -> { where(depth:0).order(position: :asc) }
  scope :sections_in, ->(level) { level.children }
  scope :titles_in, ->(section) {section.children}

  validates :name, presence: true

  def all_quizzes
    scope = Quiz.joins(:category)
    scope.where(quiz_category: { id: self_and_descendants.select(:id) })
  end
end
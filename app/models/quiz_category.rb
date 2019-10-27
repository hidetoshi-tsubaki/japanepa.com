class QuizCategory < ApplicationRecord
  acts_as_list scope: :parent_id
  acts_as_nested_set
  has_many :quizzes, foreign_key: "category_id"
  has_many :categories, -> { order(position: :asc) },foreign_key: 'parent_id', class_name: 'QuizCategory'
  has_many :mistakes, foreign_key: "title_id"
  has_many :quiz_experiences, foreign_key: 'title_id'
  belongs_to :parent, foreign_key: "parent_id", optional: true

  scope :levels, -> { where(depth:0).order(position: :asc) }
  scope :sections_in, ->(level) { level.children }
  scope :titles_in, ->(section) {section.children}
  scope :ancestors_of, ->(node) do
    left_condition  = arel_table[left_column_name].lt(node.left)
    right_condition = arel_table[right_column_name].gt(node.right)

    where(left_condition).where(right_condition)
  end

  validates :name, presence: true

  def all_quizzes
    scope = Quiz.joins(:category)
    scope.where(quiz_category: { id: self_and_descendants.select(:id) })
  end

  def is_level?
    self.root?
  end

  def is_section?
    true if self.depth == 1
  end

  def is_title?
    true if self.depth == 2
  end

  def get_ancestors
    unless self.root?
      self.ancestors
    end
  end

  def get_desendants
    if self.root
      self.descendants
    end
  end
end
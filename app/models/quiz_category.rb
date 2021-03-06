class QuizCategory < ApplicationRecord
  acts_as_list scope: :parent_id
  acts_as_nested_set
  has_many :quizzes, foreign_key: "category_id", dependent: :destroy
  has_many :categories, -> { order(position: :asc) }, foreign_key: 'parent_id', class_name: 'QuizCategory'
  has_many :mistakes, foreign_key: "title_id"
  has_many :learning_levels, foreign_key: "title_id", dependent: :destroy
  has_many :reviews, foreign_key: "title_id", dependent: :destroy
  has_many :masters, foreign_key: "title_id", dependent: :destroy
  has_many :users, through: :master
  has_one :quiz_experience, foreign_key: 'title_id', dependent: :destroy
  belongs_to :parent, foreign_key: "parent_id", optional: true

  validates :name, presence: true
  scope :levels, -> { where(depth: 0).order(position: :asc) }
  scope :sections_in, ->(level) { level.children }
  scope :titles_in, ->(section) { section.children }
  scope :ancestors_of, ->(node) do
    left_condition = arel_table[left_column_name].lt(node.left)
    right_condition = arel_table[right_column_name].gt(node.right)
    where(left_condition).where(right_condition)
  end

  def is_level?
    root?
  end

  def is_section?
    true if depth == 1
  end

  def is_title?
    true if depth == 2
  end

  def get_ancestors
    unless root?
      ancestors
    end
  end

  def get_desendants
    if root
      descendants
    end
  end

  def masterd?
    learning_levels.where(user_id: current_user.id)
  end
end

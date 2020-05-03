class LearningLevel < ApplicationRecord
  belongs_to :categories, foreign_key: "title_id", class_name: 'QuizCategory', dependent: :destroy
  belongs_to :users
  validates :user_id, :title_id, presence: :ture
  validates :user_id, :uniqueness => { :scope => :title_id }
end

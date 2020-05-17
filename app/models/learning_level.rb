class LearningLevel < ApplicationRecord
  belongs_to :title, class_name: 'QuizCategory', foreign_key: "title_id"
  belongs_to :user

  validates :user_id, :title_id, presence: :ture
  validates :user_id, :uniqueness => { :scope => :title_id }
end

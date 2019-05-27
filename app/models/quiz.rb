class Quiz < ApplicationRecord
  validates :level, :section, :title, :question, :choice1, :choice2, :choice3, :choice4, presence: true
end

class AddColumnsToQuiz < ActiveRecord::Migration[5.2]
  def change
    add_column :quizzes, :level, :integer
    add_column :quizzes, :section, :integer
    add_column :quizzes, :title, :integer
  end
end

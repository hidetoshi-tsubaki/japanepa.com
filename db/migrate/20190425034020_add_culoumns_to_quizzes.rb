class AddCuloumnsToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :level, :string
    add_column :quizzes, :section, :string
    add_column :quizzes, :title, :string
    add_column :quizzes, :question, :string
    add_column :quizzes, :choice1, :string
    add_column :quizzes, :choice2, :string
    add_column :quizzes, :choice3, :string
    add_column :quizzes, :choice4, :string
  end
end

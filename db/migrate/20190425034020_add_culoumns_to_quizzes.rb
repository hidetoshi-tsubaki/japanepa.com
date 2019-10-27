class AddCuloumnsToQuizzes < ActiveRecord::Migration[5.1]
  def up
    add_column :quizzes, :question, :string
    add_column :quizzes, :question_html, :string
    add_column :quizzes, :choice1, :string
    add_column :quizzes, :choice2, :string
    add_column :quizzes, :choice3, :string
    add_column :quizzes, :choice4, :string
  end

  def down
    remove_column :quizzes, :question, :string
    remove_column :quizzes, :question_html, :string
    remove_column :quizzes, :choice1, :string
    remove_column :quizzes, :choice2, :string
    remove_column :quizzes, :choice3, :string
    remove_column :quizzes, :choice4, :string
  end
end

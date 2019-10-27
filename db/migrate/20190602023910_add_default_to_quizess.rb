class AddDefaultToQuizess < ActiveRecord::Migration[5.2]
  def change
    change_column_null :quizzes, :question, false
    change_column_null :quizzes, :question_html, false
    change_column_null :quizzes, :choice1, false
    change_column_null :quizzes, :choice2, false
    change_column_null :quizzes, :choice3, false
    change_column_null :quizzes, :choice4, false
  end
end

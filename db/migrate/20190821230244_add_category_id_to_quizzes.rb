class AddCategoryIdToQuizzes < ActiveRecord::Migration[5.2]
  def change
    add_reference :quizzes, :category, foreign_key: { to_table: :quiz_categories}
  end
end

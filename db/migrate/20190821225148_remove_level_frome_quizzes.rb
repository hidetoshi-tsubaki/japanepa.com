class RemoveLevelFromeQuizzes < ActiveRecord::Migration[5.2]
  def up
    remove_column :quizzes, :level
    remove_column :quizzes, :section
    remove_column :quizzes, :title

  end

  def down
    add_column :quizzs, :level, :string
    add_column :quizzs, :section, :string
    add_column :quizzs, :title, :string
  end
end

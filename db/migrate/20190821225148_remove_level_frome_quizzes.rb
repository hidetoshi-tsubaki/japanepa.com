class RemoveLevelFromeQuizzes < ActiveRecord::Migration[5.2]
  def up
    remove_column :quizzes, :level
    remove_column :quizzes, :section
    remove_column :quizzes, :title

  end

  def down
    add_column :quizzes, :level, :string
    add_column :quizzes, :section, :string
    add_column :quizzes, :title, :string
  end
end

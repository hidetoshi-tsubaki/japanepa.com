class AddAwesomeNestedSetColumsToQuizCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :quiz_categories, :parent_id, :integer
    add_column :quiz_categories, :lft, :integer
    add_column :quiz_categories, :rgt, :integer
    add_column :quiz_categories, :depth, :integer
    add_column :quiz_categories, :children_count, :integer

    add_index :quiz_categories, :parent_id
    add_index :quiz_categories, :lft
    add_index :quiz_categories, :rgt
    add_index :quiz_categories, :depth
  end
end

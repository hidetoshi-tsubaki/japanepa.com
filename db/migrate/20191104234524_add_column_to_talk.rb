class AddColumnToTalk < ActiveRecord::Migration[5.2]
  def up
    add_column :talks, :likes_count, :integer
    add_column :talks, :comments_count, :integer
  end

  def down
    remove_column :talks, :likes_count, :integer
    remove_column :talks, :comments_count, :integer
  end
end

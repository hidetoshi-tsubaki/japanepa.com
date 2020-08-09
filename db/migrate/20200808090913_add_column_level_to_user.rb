class AddColumnLevelToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :level, :integer, default: 1
  end

  def down
    remove_column :users, :level, :integer, default: 1
  end
end

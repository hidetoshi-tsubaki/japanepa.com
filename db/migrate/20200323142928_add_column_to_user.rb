class AddColumnToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :delete_img, :boolean, default: false
  end

  def down
    remove_column :users, :delete_img, :boolean, default: false
  end
end

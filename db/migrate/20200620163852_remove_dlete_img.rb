class RemoveDleteImg < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :delete_img, :boolean, default: false
  end

  def down
    add_column :users, :delete_img, :boolean, default: false
  end
end

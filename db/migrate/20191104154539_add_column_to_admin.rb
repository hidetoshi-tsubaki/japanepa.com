class AddColumnToAdmin < ActiveRecord::Migration[5.2]

  def up
    add_column :admins, :name, :string
  end

  def down
    remove_column :admins, :name, :string
  end
end

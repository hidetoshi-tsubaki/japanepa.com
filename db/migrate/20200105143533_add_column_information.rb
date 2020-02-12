class AddColumnInformation < ActiveRecord::Migration[5.2]
  def up
    add_column :information, :status, :boolean, default: false
  end

  def down
    remove_column :information, :status, :boolean, default: false
  end
end

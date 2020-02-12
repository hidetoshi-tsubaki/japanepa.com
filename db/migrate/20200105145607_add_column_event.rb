class AddColumnEvent < ActiveRecord::Migration[5.2]
  def up
    add_column :events, :status, :boolean, default: false
  end

  def down
    remove_column :events, :status, :boolean, default: false
  end
end

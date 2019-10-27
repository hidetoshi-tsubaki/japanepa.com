class AddColumnCommunities < ActiveRecord::Migration[5.2]
  def up
    add_column :communities, :founder_id, :integer
  end

  def down
    remove_column :communities, :founder_id, :integer
  end
end

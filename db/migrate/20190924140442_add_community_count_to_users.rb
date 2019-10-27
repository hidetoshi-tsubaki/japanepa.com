class AddCommunityCountToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :community_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :users, :community_count
  end
end

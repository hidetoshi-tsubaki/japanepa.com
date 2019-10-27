class AddMemberCountToCommunities < ActiveRecord::Migration[5.2]
  def self.up
    add_column :communities, :member_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :communities, :member_count
  end
end

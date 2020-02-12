class AddColumnEvents < ActiveRecord::Migration[5.2]
  def up
    add_column :events, :detail, :string
    add_column :events, :impressions_count, :integer, default: 0
  end

  def down
    remove_column :events, :detail, :string
    remobe_column :events, :impressions_count, :integer, default: 0
  end
end

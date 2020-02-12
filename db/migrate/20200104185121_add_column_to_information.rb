class AddColumnToInformation < ActiveRecord::Migration[5.2]
  def up
    add_column :information, :impressions_count, :integer, default: 0
  end

  def down
    remobe_column :information, :impressions_count, :integer, default: 0
  end
end

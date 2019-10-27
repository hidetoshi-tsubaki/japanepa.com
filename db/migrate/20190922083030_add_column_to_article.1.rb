class AddColumnToArticle < ActiveRecord::Migration[5.2]
  def up
    add_column :articles, :impressions_count, :integer, default: 0
  end

  def down
    remove_column :articles, :impressions_count, :integer, default: 0
  end
end

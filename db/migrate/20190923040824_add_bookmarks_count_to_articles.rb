class AddBookmarksCountToArticles < ActiveRecord::Migration[5.2]
  def self.up
    add_column :articles, :bookmarks_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :articles, :bookmarks_count
  end
end

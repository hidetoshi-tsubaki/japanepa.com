class AddCacheToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :img_cache, :string
  end
end

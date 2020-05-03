class AddDeleteImgColumnToArticle < ActiveRecord::Migration[5.2]
  def up
    add_column :articles, :delete_img, :boolean, default: false
    remove_column :articles, :img_cache, :string
  end

  def down
    remove_column :articles, :delete_img, :boolean, default: false
    add_column :articles, :img_cache, :string
  end
end

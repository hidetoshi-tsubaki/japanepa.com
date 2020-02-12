class AddColumnArticle < ActiveRecord::Migration[5.2]
  def up
    add_column :articles, :status, :boolean, default: false
  end

  def down
    remove_column :articles, :status, :boolean, default: false
  end
end

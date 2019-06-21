class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :contents
      t.string :img

      t.timestamps
    end
  end
end

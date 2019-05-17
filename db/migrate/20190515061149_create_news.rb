class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :eyecatch
      t.string :title
      t.text :contents
      # t.enum :tag

      t.timestamps
    end
  end
end

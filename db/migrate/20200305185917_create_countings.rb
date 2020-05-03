class CreateCountings < ActiveRecord::Migration[5.2]
  def change
    create_table :countings do |t|
      t.integer :users
      t.integer :quiz_play
      t.integer :article_views
      t.integer :communities
      t.integer :talks

      t.timestamps
    end
  end
end

class CreateTalks < ActiveRecord::Migration[5.1]
  def change
    create_table :talks do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.string :img

      t.timestamps
    end
  end
end

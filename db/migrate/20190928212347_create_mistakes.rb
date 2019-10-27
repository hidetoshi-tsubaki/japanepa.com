class CreateMistakes < ActiveRecord::Migration[5.2]
  def change
    create_table :mistakes do |t|
      t.integer :count, default: 1
      t.integer :user_id
      t.integer :quiz_id
      t.integer :title_id

      t.timestamps
    end
  end
end

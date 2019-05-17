class CreateMistakes < ActiveRecord::Migration[5.1]
  def change
    create_table :mistakes do |t|
      t.references :user, foreign_key: true
      t.references :quiz, foreign_key: true
      t.integer    :count
      t.timestamps
    end
  end
end

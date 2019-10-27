class CreateScoreRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :score_records do |t|
      t.integer :score
      t.integer :title_id
      t.integer :user_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

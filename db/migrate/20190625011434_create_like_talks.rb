class CreateLikeTalks < ActiveRecord::Migration[5.2]
  def change
    create_table :like_talks do |t|
      t.references :user, foreign_key: true
      t.references :talk, foreign_key: true

      t.timestamps
    end
  end
end

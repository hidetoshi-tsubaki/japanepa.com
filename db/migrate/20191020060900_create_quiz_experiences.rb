class CreateQuizExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :quiz_experiences do |t|
      t.integer :title_id, null: false
      t.decimal :experience, null: false

      t.timestamps
    end
  end
end

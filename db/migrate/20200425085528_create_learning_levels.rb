class CreateLearningLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :learning_levels do |t|
      t.integer :percentage, default: 0
      t.integer :user_id
      t.integer :title_id

      t.timestamps
    end
  end
end

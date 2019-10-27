class CreateUserTotalExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :user_total_experiences do |t|
      t.integer :user_id
      t.integer :total_experience, default: 0

      t.timestamps
    end
  end
end

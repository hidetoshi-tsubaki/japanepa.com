class RenameTotalExperienceColumnToUserExperiences < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_experiences, :total_experience, :total_point
  end
end

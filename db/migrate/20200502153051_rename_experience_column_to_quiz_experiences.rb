class RenameExperienceColumnToQuizExperiences < ActiveRecord::Migration[5.2]
  def change
    rename_column :quiz_experiences, :experience, :rate
  end
end

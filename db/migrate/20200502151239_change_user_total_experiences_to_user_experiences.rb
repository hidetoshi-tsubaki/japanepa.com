class ChangeUserTotalExperiencesToUserExperiences < ActiveRecord::Migration[5.2]
  def change
    rename_table :user_total_experiences, :user_experiences
  end
end

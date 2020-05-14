class RemaneColumnToAnnouncementId < ActiveRecord::Migration[5.2]
  def change
    rename_column :announcement_checks, :information_id, :announcement_id
  end
end

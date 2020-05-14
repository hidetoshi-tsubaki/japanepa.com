class RenameInformationCheckToAnnouncementCheck < ActiveRecord::Migration[5.2]
  def change
    rename_table :information_checks, :announcement_checks
  end
end

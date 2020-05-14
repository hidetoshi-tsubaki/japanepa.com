class RenameInformationToAnnouncement < ActiveRecord::Migration[5.2]
  def change
    rename_table :information, :announcements
  end
end

class CreateInformationChecks < ActiveRecord::Migration[5.2]
  def change
    create_table :information_checks do |t|
      t.references :user, foreign_key: true
      t.references :information, foreign_key: true

      t.timestamps
    end
  end
end

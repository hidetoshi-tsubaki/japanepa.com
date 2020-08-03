class CreateMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :masters do |t|
      t.integer :user_id
      t.integer :title_id

      t.timestamps
    end
  end
end

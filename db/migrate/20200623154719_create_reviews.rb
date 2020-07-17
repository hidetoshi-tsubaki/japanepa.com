class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :title_id
      t.integer :count, default: 1
      t.date :next_time

      t.timestamps
    end
  end
end

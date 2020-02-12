class ChangeEventdata < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :start_time, :date
    change_column :events, :end_time, :date
  end
end

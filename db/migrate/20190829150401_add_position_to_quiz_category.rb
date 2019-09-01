class AddPositionToQuizCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :quiz_categories, :position, :integer
  end
end

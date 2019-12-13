class AddDefaultToTalk < ActiveRecord::Migration[5.2]
  def up
    change_column :talks, :likes_count, :integer, default: 0
    change_column :talks, :comments_count, :integer, default: 0
  end

  def down
    change_column_default :talks, :likes_count, nil
    change_column_default :talks, :comments_count, nil
  end
end

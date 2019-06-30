class AddImgToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :img ,:string, default: 'japanepa.png'
  end
end

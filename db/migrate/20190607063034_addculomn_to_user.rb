class AddculomnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country, :string 
    add_column :users, :current_address, :string
  end
end


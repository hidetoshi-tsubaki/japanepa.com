class AddCulomnsToCommunity < ActiveRecord::Migration[5.2]
  def change
    add_column :communities,:introduction, :string
  end
end

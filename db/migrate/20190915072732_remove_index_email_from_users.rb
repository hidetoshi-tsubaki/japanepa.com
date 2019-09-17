class RemoveIndexEmailFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, column: :email, uniue: true
  end
end

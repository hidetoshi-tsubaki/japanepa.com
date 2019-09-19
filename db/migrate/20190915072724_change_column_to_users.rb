class ChangeColumnToUsers < ActiveRecord::Migration[5.2]
  def change
  
    def up
      change_column :users, :email, :string, null: true, defoult: ""
    end

    def down
      change_column :users, :email, :string, null: false, default: ""
    end
  end
end

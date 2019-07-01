class AddLeadToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :lead, :string
  end
end

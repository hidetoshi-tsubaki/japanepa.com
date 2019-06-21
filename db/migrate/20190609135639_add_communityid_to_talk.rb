class AddCommunityidToTalk < ActiveRecord::Migration[5.2]
  def change
    add_reference :talks, :community, foreign_key: true
  end
end

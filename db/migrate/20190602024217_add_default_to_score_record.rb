class AddDefaultToScoreRecord < ActiveRecord::Migration[5.2]
  def change
        change_column_null :score_records, :score, false
        change_column_null :score_records, :quizTitle, false
        change_column_null :score_records, :user_id, false

  end
end

class DropNumericAndTextAnswerTables < ActiveRecord::Migration
  def change
    drop_table :numeric_answers
    drop_table :text_answers
  end
end

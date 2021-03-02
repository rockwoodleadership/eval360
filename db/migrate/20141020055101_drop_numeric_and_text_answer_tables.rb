class DropNumericAndTextAnswerTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :numeric_answers
    drop_table :text_answers
  end
end

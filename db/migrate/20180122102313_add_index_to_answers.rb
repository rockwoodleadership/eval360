class AddIndexToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_index :answers, [:question_id, :evaluation_id]
  end
end

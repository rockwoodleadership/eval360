class AddIndexToAnswers < ActiveRecord::Migration
  def change
    add_index :answers, [:question_id, :evaluation_id]
  end
end

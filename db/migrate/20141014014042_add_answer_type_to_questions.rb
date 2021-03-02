class AddAnswerTypeToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :answer_type, :string
  end
end

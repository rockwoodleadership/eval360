class RemoveQuestionnaireFromQuestion < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :questionnaire_id, :string
  end
end

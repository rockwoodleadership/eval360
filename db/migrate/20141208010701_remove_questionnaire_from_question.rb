class RemoveQuestionnaireFromQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :questionnaire_id, :string
  end
end

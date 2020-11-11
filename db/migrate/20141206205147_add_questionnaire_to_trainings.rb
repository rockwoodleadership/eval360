class AddQuestionnaireToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :questionnaire_id, :integer
  end
end

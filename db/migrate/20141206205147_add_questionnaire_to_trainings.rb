class AddQuestionnaireToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :questionnaire_id, :integer
  end
end

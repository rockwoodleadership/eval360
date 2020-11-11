class AddQuestionnaireToSection < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :questionnaire_id, :integer
  end
end

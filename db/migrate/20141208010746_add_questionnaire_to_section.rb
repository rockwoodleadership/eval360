class AddQuestionnaireToSection < ActiveRecord::Migration
  def change
    add_column :sections, :questionnaire_id, :integer
  end
end

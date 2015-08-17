class CreateQuestionnaireTemplates < ActiveRecord::Migration
  def change
    create_table :questionnaire_templates do |t|
      t.integer :questionnaire_id
      t.integer :section_id

      t.timestamps
    end
  end
end

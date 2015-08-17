class RemoveQuestionnaireFromSections < ActiveRecord::Migration
  def up
    remove_column :sections, :questionnaire_id
  end

  def down
    add_column :sections, :questionnaire_id, :integer

    QuestionnaireTemplate.all.each do |template|
      section = Section.where(id: template.section_id, questionnaire_id: nil).limit(1)
      section.update(questionnaire_id: template.questionnaire_id)
    end
  end
end

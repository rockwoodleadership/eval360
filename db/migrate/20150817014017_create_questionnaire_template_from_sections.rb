class CreateQuestionnaireTemplateFromSections < ActiveRecord::Migration[5.0]
  def up
   Section.all.each do |section|
     QuestionnaireTemplate.create(section_id: section.id,
                                  questionnaire_id: section.questionnaire_id)
   end 
  end

end

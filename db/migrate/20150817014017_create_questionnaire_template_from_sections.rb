class CreateQuestionnaireTemplateFromSections < ActiveRecord::Migration
  def up
   Section.all.each do |section|
     QuestionnaireTemplate.create(section_id: section.id,
                                  questionnaire_id: section.questionnaire_id)
   end 
  end

end

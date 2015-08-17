desc "Create Questionnaire From Another"
task :create_rbf_questionnaire => :environment do
  base_questionnaire = Questionnaire.where(name: 'standalone').includes(sections: :questions).first
  if base_questionnaire
    new_questionnaire = Questionnaire.create!(name: '360StandaloneRBF')
    base_questionnaire.sections.each do |section|
      QuestionnaireTemplate.create!(section_id: section.id,
                                    questionnaire_id: new_questionnaire.id) 
    end
    new_section = Section.create 
    QuestionnaireTemplate.create!(section_id: new_section.id,
                                  questionnaire_id: new_questionnaire.id)
    new_section.questions.create!(answer_type: 'text',
                                  description: 'Describe two or three personal or professional attributes that the employee should focus on (doing more of, or less of, or differently) in order to enhance his/her success as a leader?')
    new_section.questions.create!(answer_type: 'text',
                                  description: 'What additional feedback would you like offer the employee?')

  end
  
end

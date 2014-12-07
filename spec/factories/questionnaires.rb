FactoryGirl.define do
  factory :questionnaire do
    name "Questionnaire #{Time.now}"
    factory :questionnaire_with_questions do
      after(:create) do |questionnaire|
        questionnaire.sections << build(:section_with_questions, questionnaire_id: questionnaire.id)
      end
    end
  end
end

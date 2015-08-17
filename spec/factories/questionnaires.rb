FactoryGirl.define do
  factory :questionnaire do
    sequence(:name) { |n| "Questionnaire#{n}" }
    factory :questionnaire_with_questions do
      after(:create) do |questionnaire|
        section = create(:section_with_questions)
        create(:questionnaire_template, section_id: section.id, questionnaire_id: questionnaire.id)
      end
    end
  end
end

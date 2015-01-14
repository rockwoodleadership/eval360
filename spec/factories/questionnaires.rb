FactoryGirl.define do
  factory :questionnaire do
    sequence(:name) { |n| "Questionnaire#{n}" }
    factory :questionnaire_with_questions do
      after(:create) do |questionnaire|
        questionnaire.sections << build(:section_with_questions, questionnaire_id: questionnaire.id)
      end
    end
  end
end

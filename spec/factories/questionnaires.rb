FactoryGirl.define do
  factory :questionnaire do

    factory :questionnaire_with_questions do
      after(:create) do |questionnaire, evaluator|
        create_list(:question, 3, questionnaire: questionnaire, answer_type: 'numeric')
        create_list(:question, 2, questionnaire: questionnaire, answer_type: 'text')
      end
    end
  end
end

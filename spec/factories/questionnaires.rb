FactoryGirl.define do
  factory :questionnaire do
    sequence(:name) { |n| "Questionnaire#{n}" }
    factory :questionnaire_with_questions do
      after(:create) do |questionnaire|
        rand_sections = (1..3).rand
        rand_sections.times do |x|
          section = create(:section_with_questions)
          create(:questionnaire_template, section_id: section.id, questionnaire_id: questionnaire.id)
        end
      end
    end
  end
end

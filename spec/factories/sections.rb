FactoryBot.define do
  factory :section do
    header "This is a section"
    factory :section_with_questions do
      after(:create) do |section|
        section.questions << build(:question, section_id: section.id, answer_type: 'numeric')
      end
    end
  end
end

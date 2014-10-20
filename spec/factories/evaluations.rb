FactoryGirl.define do
  factory :evaluation do
    participant

    factory :self_evaluation do
      after(:create) do |evaluation|
        evaluation.evaluator = evaluation.participant
        evaluation.save
      end
    end
    factory :evaluation_with_questions do
      after(:create) do |evaluation|
        evaluation.questions << create(:question)
      end
    end
  end
end

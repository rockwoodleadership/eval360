FactoryGirl.define do
  factory :evaluation do
    participant
    evaluator
    sequence (:access_key) { |n| "access_key#{n}" }
    
    factory :self_evaluation do
      after(:build) do |evaluation|
        evaluation.self_eval = true
        evaluation.evaluator_id = evaluation.participant.evaluator.id
      end
    end
    factory :evaluation_with_questions do
      after(:create) do |evaluation|
        evaluation.questions << create(:question)
      end
    end

    factory :evaluation_with_answers do
      after(:create) do |evaluation|
        evaluation.answers << build(:answer, evaluation_id: evaluation.id)
      end
    end

    factory :self_evaluation_with_answers, parent: :self_evaluation do
      after(:create) do |evaluation|
        evaluation.answers << create(:answer, evaluation_id: evaluation.id)
      end
    end
  end
end

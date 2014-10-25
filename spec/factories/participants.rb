FactoryGirl.define do
  factory :participant do
    first_name "Sean"
    last_name "Combs"
    training
    sequence(:email) { |n| "participant#{n}@example.com" }

    factory :participant_with_self_eval do
      after(:create) do |participant|
        create(:self_evaluation, participant_id: participant.id, evaluator_id: participant.evaluator.id)
      end
    end

    factory :participant_with_self_and_peer_eval do
      after(:create) do |participant|
        evaluator = create(:evaluator)
        create(:evaluation, participant_id: participant.id, evaluator_id: evaluator.id)
        create(:self_evaluation, participant_id: participant.id, evaluator_id: participant.evaluator.id)
      end
    end

    factory :participant_with_evaluator do
      after(:create) do |participant|
        evaluator = create(:evaluator)
        create(:evaluation, participant_id: participant.id, evaluator_id: evaluator.id) 
      end
    end

    factory :participant_with_peer_evaluation do
      after(:create) do |participant|
        evaluator = create(:evaluator)
        create(:evaluation, participant_id: participant.id, evaluator_id: evaluator.id) 
      end
    end
  end
end

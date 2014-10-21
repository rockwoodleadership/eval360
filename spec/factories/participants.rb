FactoryGirl.define do
  factory :participant do
    first_name "Sean"
    last_name "Combs"
    training
    sequence(:email) { |n| "participant#{n}@example.com" }

    factory :participant_with_self_eval do
      after(:create) do |participant|
        evaluation = build(:evaluation)
        evaluation.participant = participant
        evaluation.evaluator = participant
        participant.evaluations << evaluation
      end
    end
  end
end

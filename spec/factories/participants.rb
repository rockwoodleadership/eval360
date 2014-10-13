FactoryGirl.define do
  factory :participant do
    first_name "Sean"
    last_name "Combs"
    sequence(:email) { |n| "person#{n}@example.com" }

    factory :participant_with_self_eval do

      after(:create) do |participant, evaluator|
        create_list(:evaluation, 1, participant: participant,
                    evaluator_id: participant.id)
      end
    end
  end
end

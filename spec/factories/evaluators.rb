FactoryGirl.define do
  factory :evaluator do
    sequence(:email) { |n| "evaluator#{n}@example.com" }
  end
end

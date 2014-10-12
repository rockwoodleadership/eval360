FactoryGirl.define do
  factory :participant do
    first_name "Sean"
    last_name "Combs"
    sequence(:email) { |n| "person#{n}@example.com" }
  end
end

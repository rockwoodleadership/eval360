FactoryGirl.define do
  factory :program do
    sequence(:name) { |n| "Individual Leadership Program#{n}" } 
  end
end


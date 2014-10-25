FactoryGirl.define do
  factory :program do
    sequence(:name) { |n| "Individual Leadership Program#{Time.now}" } 
    questionnaire
  end
end


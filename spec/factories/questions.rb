FactoryGirl.define do
  factory :question do
    answer_type "numeric"
    questionnaire
    description "Please rate your friend 1-4"
    self_description "Please rate yourself 1-4"
  end
end

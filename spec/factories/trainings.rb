FactoryGirl.define do
  factory :training do
    name "Art of Leadership"
    questionnaire
    start_date Date.today + 3.weeks
    end_date Date.today + 4.weeks
  end
end

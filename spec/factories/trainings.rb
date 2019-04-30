FactoryBot.define do
  factory :training do
    name "Art of Leadership"
    questionnaire
    start_date Date.current + 3.weeks
    end_date Date.current + 4.weeks
  end
end

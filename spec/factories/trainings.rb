FactoryBot.define do
  factory :training do
    name "Art of Leadership"
    questionnaire
    start_date DateTime.now + 3.weeks
    end_date DateTime.now + 4.weeks
  end
end

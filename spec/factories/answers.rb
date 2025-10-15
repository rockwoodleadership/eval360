FactoryBot.define do
  factory :answer do
    association :question
    association :evaluation
  end

  factory :text_answer, class: Answer do
    association :question, factory: :text_question
    evaluation
  end
end

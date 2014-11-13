FactoryGirl.define do
  factory :answer do
    question
    evaluation
  end

  factory :text_answer, class: Answer do
    association :question, factory: :text_question
    evaluation
  end
end

FactoryBot.define do
  factory :question do
    answer_type { "numeric" }
    description { "Please rate your friend 1-4" }
    self_description { "Please rate yourself 1-4" }
    section

    factory :text_question do
      answer_type { "text" }
    end
  end
end

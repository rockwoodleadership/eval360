class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :questionnaire, inverse_of: :questions

  validates_presence_of :answer_type
  validate :answer_type_value

  ANSWER_TYPE_VALUES = ["numeric", "text"]

  def self.generate_from_parsed_yaml(parsed_yaml)
    Question.create(answer_type: parsed_yaml.first.include?("range") ? "numeric" : "text",
                    description: parsed_yaml.last["text"],
                    self_description: parsed_yaml.last["self_text"])
  end

  private

  def answer_type_value
    if !ANSWER_TYPE_VALUES.include?(answer_type)
      errors.add(:answer_type, "must be numeric or text")
    end
  end
end

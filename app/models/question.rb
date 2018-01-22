class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :section, inverse_of: :questions

  validates_presence_of :answer_type
  validate :answer_type_value

  ANSWER_TYPE_VALUES = ["numeric", "text"]

  def self.generate_from_parsed_yaml(parsed_yaml)
    Question.create(answer_type: parsed_yaml.first.include?("range") ? "numeric" : "text",
                    description: parsed_yaml.last["text"],
                    self_description: parsed_yaml.last["self_text"],
                    legacy_tag: parsed_yaml.last["legacy_tag"])
  end

  def numeric?
    answer_type == "numeric"
  end

  private

  def answer_type_value
    if !ANSWER_TYPE_VALUES.include?(answer_type)
      errors.add(:answer_type, "must be numeric or text")
    end
  end
end

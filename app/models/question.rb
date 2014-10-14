class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :questionnaire, inverse_of: :questions

  validates_presence_of :answer_type
  validate :answer_type_value

  ANSWER_TYPE_VALUES = ["numeric", "text"]

  private

  def answer_type_value
    if !ANSWER_TYPE_VALUES.include?(answer_type)
      errors.add(:answer_type, "must be numeric or text")
    end
  end
end

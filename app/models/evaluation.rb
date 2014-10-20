class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :participant
  has_many :answers
  has_many :questions, through: :answers
  validates_uniqueness_of :access_key

  before_validation :set_access_key, on: :create

  accepts_nested_attributes_for :answers
  
  def to_param
    access_key
  end

  def build_questions
    questions = participant.program.questionnaire.questions
    questions.each do |question|
      answers.create(question: question)
    end
  end

  def header
    participant.program.questionnaire.header
  end

  def self_eval?
    participant.equal? evaluator
  end
  

  private
  
    def set_access_key
      return if access_key.present?

      begin
        self.access_key = SecureRandom.hex(8)
      end while self.class.exists?(access_key: self.access_key)
    end

end

class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :participant
  has_many :answers
  has_many :questions, through: :answers
  validates_uniqueness_of :access_key

  before_validation :set_access_key, on: :create
  
  def to_param
    access_key
  end

  def build_questions
    questions = participant.program.questionnaire.questions
    questions.each do |question|
      if question.answer_type == 'numeric'
        self.answers << NumericAnswer.new(question_id: question.id)
      elsif question.answer_type == 'text'
        self.answers << TextAnswer.new(question_id: question.id)
      end
    end
  end
  

  private
  
    def set_access_key
      return if access_key.present?

      begin
        self.access_key = SecureRandom.hex(8)
      end while self.class.exists?(access_key: self.access_key)
    end

end

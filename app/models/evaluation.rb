class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :participant
  has_many :answers, dependent: :destroy
  has_many :questions, through: :answers
  validates_uniqueness_of :access_key
  validates_presence_of :participant
  validates_presence_of :evaluator

  before_validation :set_access_key, on: :create
  after_create :build_questions

  accepts_nested_attributes_for :answers
  
  def to_param
    access_key
  end

  

  def header
    participant.program.questionnaire.header
  end

  def self_eval?
    participant.evaluator.id.equal? evaluator.id
  end

  def self.create_self_evaluation(participant)
    participant.evaluations.create(evaluator_id: participant.evaluator.id)
  end

  def title
    return "Self Evaluation" if self_eval?
    "Peer Evaluation for #{participant.first_name} #{participant.last_name}"
  end

  def intro_text
    return questionnaire.self_intro_text if self_eval?
    questionnaire.intro_text
  end

  def questionnaire
    participant.training.program.questionnaire
  end
  

  private
  
    def set_access_key
      return if access_key.present?

      begin
        self.access_key = SecureRandom.hex(8)
      end while self.class.exists?(access_key: self.access_key)
    end

    def build_questions
      questions = participant.program.questionnaire.questions
      questions.each do |question|
        answers.create(question: question)
      end
    end

end

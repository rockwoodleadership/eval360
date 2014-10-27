class Evaluation < ActiveRecord::Base
  include AccessKeys
  belongs_to :evaluator
  belongs_to :participant
  has_many :answers, -> { order "created_at ASC" }, dependent: :destroy
  has_many :questions, through: :answers
  validates_uniqueness_of :access_key
  validates_presence_of :participant
  validates_presence_of :evaluator

  before_validation :set_access_key, on: :create 
  after_create :build_questions
  after_create :set_defaults

  accepts_nested_attributes_for :answers
  
  def header
    participant.program.questionnaire.header
  end

  def self_eval?
    participant.evaluator.id.equal? evaluator.id
  end

  def self.create_self_evaluation(participant)
    participant.evaluations.create(evaluator_id: participant.evaluator.id)
  end

  def self.create_peer_evaluations(evaluators, participant)
    evaluations = []
    evaluators.each do |ev|
      evaluations << Evaluation.create(evaluator_id: ev.id, participant_id: participant.id)
    end
    evaluations
  end

  def title
    return "Self Evaluation" if self_eval?
    "Peer Evaluation for #{participant.full_name}"
  end

  def intro_text
    return questionnaire.self_intro_text if self_eval?
    questionnaire.intro_text
  end

  def questionnaire
    participant.training.program.questionnaire
  end

  def completed?
    status == 'completed'
  end

  def mark_complete
    self.status = 'completed'
    self.save
  end
  

  private
  
    def build_questions
      questions = participant.program.questionnaire.questions
      questions.each do |question|
        answers.create(question: question)
      end
    end

    def set_defaults
      return if !status.nil?
      self.status = 'created'
      self.save
    end

end

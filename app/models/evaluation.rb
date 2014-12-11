require 'evaluation_emailer'
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


  def self_eval?
    participant.evaluator.id.equal? evaluator.id
  end

  def eval_type_str
    self_eval? ? "Self Evaluation" : "Peer Evaluation"
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
    participant.training.questionnaire
  end

  def mark_complete
    self.completed = true
    self.save
  end

  def email_to_evaluator
    if self_eval?
      EvaluationEmailer.send_invite_for_self_eval(participant)
    else
      EvaluationEmailer.send_peer_invites([self])
    end
  end
  

  private
  
    def build_questions
      questions = participant.training.questionnaire.questions
      questions.each do |question|
        answers.create(numeric_response: 0, text_response: "", question: question)
      end
    end

    def set_defaults
      return if completed? 
      self.completed = false
      self.save
    end

end

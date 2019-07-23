require 'evaluation_emailer'
class Evaluation < ActiveRecord::Base
  include AccessKeys
  belongs_to :evaluator
  belongs_to :participant
  has_many :answers, -> { includes(:question => :section).order("created_at ASC") }, dependent: :destroy
  has_many :questions, through: :answers
  validates_uniqueness_of :access_key
  validates_presence_of :participant
  validates_presence_of :evaluator

  before_validation :set_access_key, on: :create 
  after_create :build_questions
  after_create :set_defaults

  accepts_nested_attributes_for :answers

  def eval_type_str
    self_eval? ? "Self Assessment" : "Peer Assessment"
  end

  def self.create_self_evaluation(participant)
    participant.evaluations.create(evaluator_id: participant.evaluator.id, self_eval: true)
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

  def questionnaire
    participant.training.questionnaire
  end

  def mark_complete
    self.completed = true
    self.save
  end

  def not_accessible?
    if self.evaluator.declined? or Date.today > participant.training.end_date
      ##reverting Date.current to Date.today
      return true
    end
    return false
  end

  private
  
    def build_questions
      questions = participant.training.questionnaire.questions
      questions.each do |question|
        answers.create(numeric_response: nil, text_response: "", question: question)
      end
    end

    def set_defaults
      return if completed? 
      self.completed = false
      self.save
    end

end

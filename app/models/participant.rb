class Participant < ActiveRecord::Base
  include AccessKeys
  include ParticipantStatus


  acts_as :evaluator
  has_many :evaluations, -> { order "created_at ASC" }, dependent: :destroy
  has_many :evaluators, through: :evaluations
  accepts_nested_attributes_for :evaluators, :reject_if => :all_blank, :allow_destroy => true
  belongs_to :training, inverse_of: :participants
  validates_presence_of :training
  validates_uniqueness_of :access_key

  before_validation :set_access_key, on: :create
  after_create :create_self_evaluation

  def self_evaluation
    evaluations.where(evaluator_id: self.evaluator.id).first
  end

  def peer_evaluation_status
    "#{completed_peer_evaluations} of #{total_peer_evaluations}"
  end

  def completed_peer_evaluations
    count = 0
    peer_evaluations.each { |pe| count += 1 if pe.completed? && !pe.evaluator.declined? }
    count
  end

  def total_peer_evaluations
    peer_evaluations.count
  end

  def peer_evaluations
    pes = []
    evaluations.includes(:evaluator).where("evaluator_id != ?", self.evaluator.id ).each do |pe|
      pes << pe unless pe.evaluator.declined?
    end
    pes
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def peer_evaluators
    evs = []
    invited_peers.each do |ev|
      evs << ev unless ev.declined?
    end 
    evs
  end

  def invited_peers
    evaluators.where.not(id: self.evaluator.id)
  end

  def declined_peers
    evs = []
    invited_peers.each do |ev|
      evs << ev if ev.declined?
    end
    evs
  end

  def peer_evals_not_completed
    evs = evaluations.where("completed = ? AND evaluator_id != ?", false, self.evaluator.id )
    incomplete_evals = []
    evs.each do |e|
      incomplete_evals << e unless e.evaluator.declined?
    end
    incomplete_evals
  end

  def invite
    email_type = "self-invite-#{training.questionnaire.name}"
    EvaluationEmailer.send_to_participant(email_type, self)
  end

  def remind
    email_type = "self-reminder-#{training.questionnaire.name}"
    EvaluationEmailer.send_to_participant(email_type, self)
    self.assessment_reminder_sent_date = Date.today
    self.save
    update_salesforce
  end

  def remind_to_add_peers
    email_type = "add-peer-#{training.questionnaire.name}"
    EvaluationEmailer.send_to_participant(email_type, self)
    self.reminder_for_peer_assessment_sent_date = Date.today
    self.save
    update_salesforce
  end

  def remind_to_remind_peers
    EvaluationEmailer.remind_peers_reminder(participant)
  end

  private
  
  def create_self_evaluation
    Evaluation.create_self_evaluation(self)
    self.assessment_sent_date = Date.today
    self.save
    update_salesforce
  end

end

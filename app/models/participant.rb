class Participant < ActiveRecord::Base
  include AccessKeys

  acts_as :evaluator
  has_many :evaluations
  has_many :evaluators, through: :evaluations
  accepts_nested_attributes_for :evaluators, :reject_if => :all_blank, :allow_destroy => true
  belongs_to :training, inverse_of: :participants
  validates_presence_of :training
  validates_uniqueness_of :access_key

  before_validation :set_access_key, on: :create

  def self_evaluation
    evaluations.where(evaluator_id: self.evaluator.id).first
  end

  def program
    self.training.program
  end

  def peer_evaluation_status
    "#{completed_peer_evaluations} of #{total_peer_evaluations}"
  end

  def completed_peer_evaluations
    evaluations.where("status = ? AND evaluator_id != ?", 'completed', self.evaluator.id ).count
  end

  def total_peer_evaluations
    evaluations.where("evaluator_id != ?", self.evaluator.id ).count
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def peer_evaluators
    evaluators.where.not(id: self.evaluator.id)
  end

  def peer_evals_not_completed
    evaluations.where("status != ? AND evaluator_id != ?", 'completed', self.evaluator.id )
  end

end

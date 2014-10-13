class Participant < ActiveRecord::Base
  acts_as :evaluator
  has_many :evaluations

  def self_evaluation
    evaluations.where(participant_id: self.id).first
  end
end

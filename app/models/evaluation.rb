class Evaluation < ActiveRecord::Base
  has_one :evaluator
  validates_uniqueness_of :access_key
  validates_presence_of :participant_id

  before_validation :set_access_key, on: :create

  def send_invite
    return true
  end

  def self.create_and_send_self_eval(participant)
    evaluation = Evaluation.new do |e|
      e.participant_id = participant.id
      e.evaluator = participant
    end

    if evaluation.save!
      EvaluationEmailer.send_invite_for_self(evaluation)
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

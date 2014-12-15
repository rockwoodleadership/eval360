class Training < ActiveRecord::Base
  has_many :participants, -> { order "first_name ASC" }, inverse_of: :training 
  accepts_nested_attributes_for :participants
  belongs_to :questionnaire

  validates_presence_of :questionnaire_id

  def self.send_self_eval_reminders
    upcoming_trainings = Training.includes(:participants).where("start_date IN (?)", Date.today..30.days.from_now)
    
    upcoming_trainings.each do |training|
      training.participants.each do |participant|
        participant.remind unless participant.self_evaluation.completed?
      end
    end
  end

  def self.send_add_peers_reminders
    upcoming_trainings = Training.includes(:participants).where("start_date IN (?)", Date.today..30.days.from_now)
    
    upcoming_trainings.each do |training|
      training.participants.each do |participant|
        participant.remind_to_add_peers if participant.total_peer_evaluations.zero?
      end
    end
  end

  def self.send_remind_peers_reminders
    upcoming_trainings = Training.includes(:participants).where("start_date IN (?)", Date.today..30.days.from_now)
    
    upcoming_trainings.each do |training|
      training.participants.each do |participant|
        if participant.total_peer_evaluations > 0 && participant.completed_peer_evaluations < 10
          participant.remind_to_remind_peers
        end
      end
    end
  end

end

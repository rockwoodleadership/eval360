class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :evaluation

  validates_presence_of :question
  validates_presence_of :evaluation

  scope :non_zero, -> { where 'numeric_response > 0' }
  scope :peers, -> { joins(:evaluation).where("evaluations.self_eval != ?", true) }
  scope :completed, -> { joins(:evaluation).where("evaluations.completed = ?", true) }

  def response
    if question.answer_type == "numeric"
      if numeric_response.nil? || numeric_response.zero?
        "not applicable"
      else
        numeric_response
      end
    else
      if text_response.nil? || text_response.empty? 
        "no response"
      else
        text_response
      end
    end

  end


  def set_default_values
    self.numeric_response = 0 
    self.text_response = "" 
    self.save
  end

  def self.peer_assessment_scores(question_id, participant_id)
    owner_scores = {}
    answers = Answer.joins(:evaluation).where('evaluations.participant_id != ?', participant_id)
    answers.where(question_id: question_id).non_zero.completed.peers.each do |answer|
      participant_id = answer.evaluation.participant_id
      owner_scores[participant_id] = [] if !owner_scores[participant_id]
      owner_scores[participant_id].push answer.numeric_response
    end
    owner_scores.map {|k,v| v.sum.to_f/v.length }
  end
end

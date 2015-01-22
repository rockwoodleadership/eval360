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
    owner_scores = Answer.joins(:evaluation, :question).where(:evaluations => {self_eval: false,
                                                     completed:true},
                                                     :questions => {answer_type: 'numeric', id: question_id}).
                                                     where.not(:evaluations => { participant_id: participant_id }).
                                                     where.not(numeric_response: 0).
                                                     where.not(numeric_response: nil).
                                                     group('evaluations.participant_id').
                                                     average(:numeric_response)
    owner_scores.map {|k,v| v.to_f }
  end
end

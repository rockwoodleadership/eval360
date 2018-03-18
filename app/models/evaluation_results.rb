class EvaluationResults

  def initialize(participant)
    @participant = participant
  end

  def histogram_for_q(answers)
    histogram = Array.new(11) {|i| 0}
    answers.each do |a|
      histogram[a] += 1 unless a.nil? || a.zero?
    end
    return histogram
  end

  def self_score_for_q(question_id)
    self_evaluation.answers.find_by(question_id: question_id).numeric_response
  end

  def mean_score_for_q(answers)
    answers.any? ? answers.sum.to_f/answers.length : nil
  end

  def numeric_answers_for_q(question_id)
    Answer.joins(:evaluation, :question).where(:evaluations => {self_eval: false,
                                                     participant_id: @participant.id,
                                                     completed:true},
                                               :questions => {id: question_id, answer_type: 'numeric'}).
                                                     where.not(numeric_response: 0).
                                                     where.not(numeric_response: nil).
                                                     pluck(:numeric_response)
  end

  def mean_score_for_s(section)
    Answer.joins(:evaluation, :question).where(:evaluations => {self_eval: false,
                                                     participant_id: @participant.id,
                                                     completed:true},
                                    :questions => {section_id: section.id, answer_type: 'numeric'}).
                                                     where.not(numeric_response: 0).
                                                     where.not(numeric_response: nil).
                                                     calculate(:average, :numeric_response).to_f.round(2)
  end

  def text_answers_for_q(question_id)
    Answer.joins(:evaluation, :question).where(:evaluations => {self_eval: false,
                                                     participant_id: @participant.id,
                                                     completed:true},
                                    :questions => {id: question_id, answer_type: 'text'}).
                                                     where.not(text_response: "").
                                                     where.not(text_response: nil).
                                                     pluck(:text_response)
  end

  def self_answer_for_q(question_id)
    self_evaluation.answers.find_by(question_id: question_id).text_response
  end

  private

  def self_evaluation
    @participant.self_evaluation
  end

  def peer_evaluations
    @participant.peer_evaluations
  end

  

end

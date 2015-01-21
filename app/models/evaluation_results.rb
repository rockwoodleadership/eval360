class EvaluationResults

  def initialize(participant)
    @participant = participant
  end

  def histogram_for_q(answers)
    histogram = []
    0.upto(10) { histogram.push(0) }
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
    answers_for_q = peer_evaluations.flat_map { |pe| pe.answers.where(question_id: question_id) }
    answers = answers_for_q.keep_if { |a| !a.numeric_response.nil? && !a.numeric_response.zero? }
    answers.map! {|a| a.numeric_response}
  end

  def mean_score_for_s(section)
    scores = []
    section.questions.each do |question|
      answers = numeric_answers_for_q(question.id)
      mean = mean_score_for_q(answers)
      scores <<  mean if mean
    end
    scores.any? ? scores.sum.to_f/scores.length : nil
  end

  def quartile_rank( score, all_scores )
    lower_scores = all_scores.select{ |value| !value.nil? && value < score }.size
    return 4 if lower_scores.zero?
    quartile_size = all_scores.size.to_f / 4.0
    case
      when lower_scores > quartile_size * 3
        1
      when lower_scores > quartile_size * 2
        2
      when lower_scores > quartile_size
        3
      else 
        4 
      end
  end

  def rw_quartile(question_id, eval_mean)
    rw_dataset = Answer.peer_assessment_scores(question_id, @participant.id) 
    question = Question.find(question_id)
    if question.legacy_tag
      @legacy_values = LegacyMeanScores.mean_scores question.legacy_tag
      rw_dataset +=  @legacy_values if @legacy_values
    end
    return 0 if rw_dataset.empty? 
    quartile_rank eval_mean, rw_dataset
  end

  def text_answers_for_q(question_id)
    answers_for_q = peer_evaluations.flat_map { |pe| pe.answers.where(question_id: question_id) }
    answers = answers_for_q.keep_if { |a| !a.text_response.nil? && !a.text_response.blank? }
    answers.map {|a| a.text_response }
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

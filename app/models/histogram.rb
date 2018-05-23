class Histogram

  def initialize(participant, question)
    @question = question
    @participant = participant

  end

  def frequency
    histogram = Array.new(11) {|i| 0}
    answers.each do |a|
      histogram[a] += 1 unless a.nil? || a.zero?
    end
    return histogram
  end

  def mean
    answers.any? ? answers.sum.to_f/answers.length : nil
  end

  def self_score
    @participant.self_evaluation.answers.find_by(question_id: @question.id).
      numeric_response
  end

  def rw_quartile
    rw_dataset = Answer.peer_assessment_scores(@question.id, @participant.id) 
    if @question.legacy_tag
      legacy_values = LegacyMeanScores.mean_scores @question.legacy_tag
      rw_dataset +=  legacy_values if legacy_values
    end
    return 0 if rw_dataset.empty? || mean.nil? 
    quartile_rank mean, rw_dataset
  end

  def loi?
    @participant.training.questionnaire.name == Rails.configuration.x.loi
  end

  private

  def answers
    @answers ||= Answer.joins(:evaluation, :question).
      where(:evaluations => { self_eval: false,
                             participant_id: @participant.id,
                             completed: true },
            :questions => { id: @question.id,
                           answer_type: 'numeric' }).
      where.not(numeric_response: 0).
      where.not(numeric_response: nil).
      pluck(:numeric_response)
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
end

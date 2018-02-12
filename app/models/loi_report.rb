class LOIReport < Report
  def initialize(participant)
    super(participant)
    sections
    average_section_scores
  end

  def sections
    @sections ||= participant.training.questionnaire.sections
  end

  def average_section_score(section)
    @averages[section.id.to_s]
  end

  def top_8_scores
    @mean_scores.first(8)
  end

  def bottom_8_scores
    @mean_scores.last(8).reverse
  end
  private

  def average_section_scores
    @averages = {}
    sections.each do |s|
      @averages[s.id.to_s] = get_section_score(s)
    end
  end

  def get_section_score(section)
    Answer.joins(:evaluation, :question).where(:evaluations => {self_eval: false,
                                                     participant_id: participant.id,
                                                     completed:true},
                                               :questions => {section_id: section.id,
                                                              answer_type: 'numeric'}).
                                         where.not(numeric_response: 0).
                                         where.not(numeric_response: nil).
                                         calculate(:average, :numeric_response).
                                         to_f.round(2)

  end
end

class Report
  attr_reader :participant
  attr_reader :results
  delegate :full_name, to: :participant, prefix: true
  delegate :self_score_for_q, to: :results
  delegate :text_answers_for_q, to: :results
  delegate :self_answer_for_q, to: :results

  def initialize(participant)
    @participant = participant
    questions = Question.joins(:answers).
      where(answers: {evaluation_id: participant.self_evaluation.id})
    @peer_numeric_responses = Answer.joins(:evaluation, :question).
      where(:evaluations => { self_eval: false,
                             participant_id: participant.id,
                             completed: true },
            :questions => { id: questions.pluck(:id),
                           answer_type: 'numeric' }).
      where.not(numeric_response: 0).
      where.not(numeric_response: nil)
    @results = EvaluationResults.new(participant)
    @mean_scores = []
  end

  def histogram(question_id)
    results.histogram_for_q(answers(question_id))
  end

  def mean_score_for_q(question_id)
    mean_score = results.mean_score_for_q(answers(question_id))
    save_mean_scores(mean_score, question_id)
    mean_score
  end

  def rw_quartile(question_id)
    avg = mean_score_for_q(question_id)
    results.rw_quartile(question_id, avg)
  end

  def sections
    evaluation_id = participant.self_evaluation.id
    Section.joins("INNER JOIN questions ON questions.section_id = sections.id").
      merge( Question.joins("INNER JOIN answers ON questions.id = answers.question_id WHERE answers.evaluation_id = #{evaluation_id}") ).
      uniq
  end

  def training_name
    participant.training.name
  end

  def top_4_scores
    mean_scores.first(4)
  end

  def bottom_4_scores
    mean_scores.last(4).reverse
  end

  private

  def answers(question_id)
    @peer_numeric_responses.where(question_id: question_id).pluck(:numeric_response)
  end

  def mean_scores
    calculate_mean_scores if @mean_scores.empty?
    @mean_scores.sort! { |a,b| b[:mean_score] <=> a[:mean_score] }
    @mean_scores = @mean_scores.uniq
  end

  def calculate_mean_scores
    if @mean_scores.empty?
      participant.self_evaluation.questions.each do |q|
        mean_score_for_q(q.id)
      end
    end
  end

  def save_mean_scores(mean_score, question_id)
    question = Question.find(question_id)
    if mean_score && question
      question_num = participant.self_evaluation.questions.index(question)
      question_num += 1 if question_num
      info = {
        position: question_num,
        mean_score: mean_score,
        description: question.self_description
      }
    end
    @mean_scores.push(info) if mean_score
  end
end

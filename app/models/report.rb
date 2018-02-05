class Report
  attr_reader :participant
  attr_reader :results
  delegate :full_name, to: :participant, prefix: true
  delegate :access_key, to: :participant, prefix: true
  delegate :text_answers_for_q, to: :results
  delegate :self_answer_for_q, to: :results

  def initialize(participant)
    @participant = participant
    questions
    @peer_numeric_responses = Answer.joins(:evaluation, :question).
      where(:evaluations => { self_eval: false,
                             participant_id: participant.id,
                             completed: true },
            :questions => { id: questions.pluck(:id),
                           answer_type: 'numeric' }).
      where.not(numeric_response: 0).
      where.not(numeric_response: nil)
    mean_scores
    @results = EvaluationResults.new(participant)
  end

  def questions
    @questions ||= Question.joins(:answers).
      where(answers: {evaluation_id: participant.self_evaluation.id})
  end

  def training_name
    participant.training.name
  end

  def top_4_scores
    @mean_scores.first(4)
  end

  def bottom_4_scores
    @mean_scores.last(4).reverse
  end

  private

  def answers(question_id)
    @peer_numeric_responses.where(question_id: question_id).pluck(:numeric_response)
  end

  def mean_scores
    @mean_scores = []
    questions.each do |q|
      q_answers = answers(q.id)
      if q_answers.any?
        mean_score = mean_score(q_answers)
      end
      save_mean_scores(mean_score, q.id)
    end
    @mean_scores.sort! { |a,b| b[:mean_score] <=> a[:mean_score] }
    @mean_scores = @mean_scores.uniq
  end

  def mean_score(answers)
    answers.sum.to_f/answers.length
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

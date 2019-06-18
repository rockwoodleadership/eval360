class ReportPdf < Prawn::Document

  TOP_OF_PAGE = 775
  BOTTOM_OF_PAGE = 100
  BLOCK_HEIGHT = 130
  PAGE_WIDTH = 500
  HEADER_HEIGHT = 120

  LAYOUT_LINE = 12
  LAYOUT_SCALE = 40

  def initialize(participant)
    super()
    @participant = participant
    @questions = participant.self_evaluation.questions
    @results = EvaluationResults.new(participant)
    @mean_scores = []
    print_header
    print_questions 
    @mean_scores.sort! { |a,b| b[:mean_score] <=> a[:mean_score] }
    print_top_bottom_results
  end

  def print_header
    text @participant.training.name, style: :bold
    text "Evaluation for: #{@participant.full_name}"
    @block_start = TOP_OF_PAGE - HEADER_HEIGHT
  end

  def print_section_header(section)
    unless section.header.blank? || section.header.nil?
      bounding_box [0, @block_start+5], width: PAGE_WIDTH do
        text "#{section.header}", style: :bold, size: 14
        for_individual_program = (@participant.training.questionnaire.name == 'YearlongIndividual') ? true : false
        if for_individual_program
          section_mean = @results.mean_score_for_s(section)
          text("Average score for this section: #{section_mean}", size:12) unless section_mean.nil?
        end
      end
      @block_start -= 120
    end
  end

  def print_questions
    section_ids = []
    @questions.each do |question|
      unless section_ids.include?(question.section.id)
        if section_ids.any?
          start_new_page
          print_header
        end
        section_ids << question.section.id
        print_section_header(question.section)
      end
      if question.answer_type == "numeric"
        check_start_new_page
        print_numeric_answers(question)
        @block_start -= BLOCK_HEIGHT
      else
        start_new_page
        print_text_answers(question)
      end
    end
  end

  def check_start_new_page
    if @block_start < BOTTOM_OF_PAGE
      start_new_page
      print_header
    end 
  end

  def print_top_bottom_results
    program_name = @participant.training.questionnaire.name
    start_new_page
    if (program_name == 'YearlongIndividual' || program_name == 'YearlongPerformance')
      print_top_8
      print_bottom_8
    else
      print_top_4
      print_bottom_4
    end
  end

  def print_numeric_answers(question)
    question_num = @questions.index(question)+1
    bounding_box [0, @block_start + 50], width: PAGE_WIDTH do
       text "\n\n#{question_num}. #{question.self_description}", :style=>:bold
    end
    bounding_box [ 0, @block_start - 100 ], width: PAGE_WIDTH do
      draw_endpoints
      answers = @results.numeric_answers_for_q(question.id)
      draw_histogram @results.histogram_for_q(answers)
      draw_text "Self Score: %0.1f" % @results.self_score_for_q(question.id), at: [ 0, LAYOUT_LINE*2 ], size: 10
      mean_score = @results.mean_score_for_q(answers)
      if mean_score
        info = {
          position: question_num,
          mean_score: mean_score,
          description: question.self_description
        }
        @mean_scores.push(info)
        draw_text "Average score: %0.1f" % mean_score, at: [ 0, LAYOUT_LINE*3 ], size: 10
      else
        draw_text "Average score:", at: [ 0, LAYOUT_LINE*3 ], size: 10
      end
      rw_quartile = @results.rw_quartile(question.id, mean_score)
      if rw_quartile
        draw_text "Rockwood quartile: #{rw_quartile}", :at=>[ 350, LAYOUT_LINE*3 ], :size => 10
      end
    end

  end

  
  def print_text_answers(question)
  
    font_families.update(
        'DejaVuSans' => { :normal => 'app/assets/fonts/DejaVuSans.ttf', 
                          :bold => 'app/assets/fonts/DejaVuSans-Bold.ttf'},
        )

    font('DejaVuSans') do
  
      text "\n\n#{@questions.index(question)+1}. #{question.self_description}", :style=>:bold
    
    text_answers = @results.text_answers_for_q(question.id)
    text_answers.each do |answer|
      text "- " + answer + "\n\n" unless answer.nil?
    end
    text "\n\nYou Answered:\n\n", style: :bold
    text @results.self_answer_for_q(question.id)

  end

  end

  def print_top_8
    text "\nTop 8 Scores:", style: :bold, size: 14
    print_q_summary @mean_scores.first(8) 
  end

  def print_bottom_8
    text "\nBottom 8 Scores:", :style=>:bold, :size => 14
    print_q_summary @mean_scores.last(8).reverse
  end

  def print_top_4
    text "\nTop 4 Scores:", style: :bold, size: 14
    print_q_summary @mean_scores.first(4)
  end

  def print_bottom_4
    text "\nBottom 4 Scores:", :style=>:bold, :size => 14
    print_q_summary @mean_scores.last(4).reverse
  end

  def print_q_summary(scores)
    scores.each do |q|
      text "\n#%s. (%0.1f) %s" % [ q[:position], q[:mean_score], q[:description] ]
    end
  end

  def draw_endpoints
    text_box "Almost Never", at: [0, LAYOUT_LINE * 8], size: 8
    text_box "Almost Always", at: [LAYOUT_SCALE * 10, LAYOUT_LINE * 8], align: :right, size: 8
  end

  def draw_histogram(histogram)
    line_width(2)
    1.upto(10) do |x|
      draw_text "#{x.to_s}", at: [LAYOUT_SCALE * x, LAYOUT_LINE * 5]
      if histogram[x] > 0
        draw_text "{#{histogram[x]}}", at: [LAYOUT_SCALE * x, LAYOUT_LINE * 6], style: :bold, size: 10 
      end
    end
  end

end


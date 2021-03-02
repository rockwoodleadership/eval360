class ReportsController < ApplicationController
  layout 'report' 

  def show
    if participant.training.questionnaire.name == Rails.configuration.x.loi
      @report = LOIReport.new(participant)
      render 'loi_report'
    else
      @report = Report.new(participant)
    end
  end

  def histogram
    question = Question.find(params[:question_id])
    if question
      @histogram = Histogram.new(participant, question)
      render :partial => "histogram"
    end
  end

  private

  def participant
    Participant.find_by(access_key: params[:participant_id])
  end
end

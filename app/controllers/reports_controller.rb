class ReportsController < ApplicationController
  layout 'report'

  def show
    @report = Report.new(participant)
  end

  def histogram
    question = Question.find(params[:question_id])
    @histogram = Histogram.new(participant, question)
    render :partial => "histogram"
  end

  private

  def participant
    Participant.find_by(access_key: params[:participant_id])
  end
end

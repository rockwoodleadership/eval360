class ReportsController < ApplicationController
  layout 'report'

  def show
    participant = Participant.find_by_access_key(params[:participant_id])
    @report = Report.new(participant)
  end
end

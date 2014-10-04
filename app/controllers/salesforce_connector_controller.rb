class SalesforceConnectorController < ApplicationController
  def new_participant
    Participant.create(params[:participant])
    render json: 'success', status: 200
  end
end

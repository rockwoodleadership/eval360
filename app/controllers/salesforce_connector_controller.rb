class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session
  def new_participant

    if params[:participant] && params[:participant].is_a?(String) 
      participant = JSON.parse(params[:participant])

      attributes = { first_name: participant['First_Name__c'],
                      last_name: participant['Last_Name__c'],
                      email: participant['Email__c'] }
      Participant.create(attributes)
      render json: 'success', status: 200
    else
      render json: 'invalid params', status: 422
    end
  end
end

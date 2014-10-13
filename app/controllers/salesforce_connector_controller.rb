class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session

  def new_participant
    if params[:participant] && params[:participant].is_a?(String) 
      hash = JSON.parse(params[:participant])

      attributes = { first_name: hash['First_Name__c'],
                      last_name: hash['Last_Name__c'],
                      email: hash['Email__c'] }
      participant = Participant.create!(attributes)
       
      if participant && participant.errors.empty?
        participant.evaluations.create(evaluator_id: participant.id)
        EvaluationEmailer.send_invite_for_self_eval(participant)
        render json: 'success', status: 200 and return
      end
    end

    render json: 'something went wrong', status: 422
  end

  

end

module ParticipantStatus

  EVAL_STATUSES = ["Not Started", "Needs to Send Peer Invites",
                   "Sent Peer Invites", "Peer Evaluations Incomplete",
                   "360 Evaluation Completed"]

  def added_peer_evaluators
    #update_salesforce
  end

  def completed_self_eval
    self_evaluation.mark_complete
    #update_salesforce
  end

  def peer_evaluation_completed(evaluation)
    evaluation.mark_complete
    EvaluationEmailer.send_thank_you(evaluation)
    #update_salesforce
  end

  private

  def update_salesforce
    #client = Databasedotcom::Client.new host: "test.salesforce.com" 

    if evaluation_complete?
      status = EVAL_STATUSES.last
    elsif self_evaluation.completed?
      if completed_peer_evaluations > 0 
        status = EVAL_STATUSES[3]
      elsif peer_evaluators.any?
        status = EVAL_STATUSES[2]
      else
        status = EVAL_STATUSES[1]
      end
    else
      status = EVAL_STATUSES.first
    end

    #todo verify class name and evaluation status field
    #client.update('Registration', sf_registration_id,
    #              {"Evaluation_Status" => status} )
  end


end

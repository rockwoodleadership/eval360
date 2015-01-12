module ParticipantStatus

  EVAL_STATUSES = ["Needs to Complete Self-Assessment", "Needs to Send Peer Invites",
                   "Peer Assessment Incomplete",
                   "360 Assessment Completed"]

  def added_peer_evaluators
    update_salesforce
  end

  def completed_self_eval
    self_evaluation.mark_complete
    update_salesforce
  end

  def peer_evaluation_completed(evaluation)
    evaluation.mark_complete
    EvaluationEmailer.send_thank_you(evaluation)
    EvaluationEmailer.send_evaluation_done(self) if evaluation_complete?
    update_salesforce
  end

  private

  def update_salesforce
    

    if evaluation_complete?
      status = EVAL_STATUSES.last
    elsif self_evaluation.completed?
      if completed_peer_evaluations < 10 
        status = EVAL_STATUSES[2]
      elsif peer_evaluators.empty?
        status = EVAL_STATUSES[1]
      end
    else
      status = EVAL_STATUSES.first
    end

    # client = Databasedotcom::Client.new host: "test.salesforce.com" 
    # client.authenticate :username => ENV['SALESFORCE_USERNAME'], :password => ENV['SALESFORCE_PASSWORD']

    #todo verify class name and evaluation status field
    # client.update('Registration', sf_registration_id,
    #               {"ruby360_Assessment_Status__c" => status} )
  end

  def evaluation_complete?
    self_evaluation.completed? && (completed_peer_evaluations > 9)
  end


end

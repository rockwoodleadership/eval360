module ParticipantStatus

  EVAL_STATUSES = ["Needs to Complete Self-Assessment", "Needs to Send Peer Invites",
                   "Peer Assessment Incomplete",
                   "360 Assessment Completed"]

  def added_peer_evaluators
    self.peer_assessment_sent_date = Date.today
    self.save
    update_salesforce
  end

  def completed_self_eval
    self_evaluation.mark_complete
    update_salesforce
  end

  def peer_evaluation_completed(evaluation)
    evaluation.mark_complete
    EvaluationEmailer.send_thank_you(evaluation)
    if evaluation_complete? && assessment_complete_date.nil?
      EvaluationEmailer.send_evaluation_done(self)
      self.assessment_complete_date = Date.today
      self.save
    end
    update_salesforce
  end

  private

  def update_salesforce
    
    if evaluation_complete?
      status = EVAL_STATUSES.last
    elsif self_evaluation.completed?
      if peer_evaluators.empty?
        status = EVAL_STATUSES[1]
      else
        status = EVAL_STATUSES[2]
      end
    else
      status = EVAL_STATUSES.first
    end

    client = Databasedotcom::Client.new host: "test.salesforce.com" 
    client.authenticate :username => ENV['SALESFORCE_USERNAME'], :password => ENV['SALESFORCE_PASSWORD']
    participant_url = "http://#{Rails.application.config.action_mailer.default_url_options[:host]}" +
                      "/admin/trainings/#{training.id}/participants/#{access_key}"

    client.update('Registration__c', sf_registration_id,
                  { "ruby360_Assessment_Status__c" => status, 
                    "ruby360_URL__c" => participant_url,
                    "ruby360_Peer_Complete_Number__c" => completed_peer_evaluations,
                    "ruby360_Assessment_Sent_Date__c" => assessment_sent_date,
                    "ruby360_Peer_Assess_Invite_Sent__c" => peer_assessment_sent_date,
                    "ruby360_Reminder_for_Peer_Assess_Sent__c" => reminder_for_peer_assessment_sent_date,
                    "ruby360_Self_Assess_Reminder_Sent__c" => assessment_reminder_sent_date,
                    "ruby360_Completed_Email_Sent__c" => assessment_complete_date    
                  } )
  end
  handle_asynchronously :update_salesforce

  def evaluation_complete?
    self_evaluation.completed? && (completed_peer_evaluations > 9)
  end


end

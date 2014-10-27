require 'mandrill'
class EvaluationEmailer

  def self.send_invite_for_self_eval(participant)
    
    
    #todo: use template name from training
    #get training Training.find(participant.training_id)

    template_name = "self-eval-invitation-demo"
    message = {
      "subject" => "Welcome to Rockwood Leadership",
      "global_merge_vars" => [{ "name" => "FIRST_NAME",
                                "content" => participant.first_name },
                              { "name" => "LAST_NAME",
                                "content" =>  participant.last_name },
                              { "name" => "EVAL_URL",
                                "content" =>  "https://staging-rockwood.herokuapp.com/evaluations/#{participant.self_evaluation.access_key}/edit" }],
      "merge" => true,
      "to" => [{ "email" => participant.email, 
                 "name" => "#{participant.first_name} #{participant.last_name}",
                 "type" => "to" }]
      
    }
    send_template(template_name, message) 
  end


  def self.send_peer_invites(evaluations)
    
    template_name = "peer-eval-invitation-demo"
    message = generate_message(evaluations)
    send_template(template_name, message)
    
  end

  def self.send_peer_reminders(participant, custom_message)
    evaluations = participant.peer_evals_not_completed
    if custom_message
      template_name = 'peer-eval-custom-reminder-demo'
      message = generate_message(evaluations)       
      message["global_merge_vars"] << { "name" => "CUSTOM_MESSAGE",
                                        "content" => custom_message }
      send_template(template_name, message)
    else
      send_peer_invites(evaluations)
    end
  end

  private
    def self.send_template(template_name, message)
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
      results = mandrill.messages.send_template(template_name, [], message)
      sent_count = 0
      results.each do |result|
        if result['status'] == 'sent'
          sent_count = sent_count + 1
        else
          puts result
        end
      end
      return sent_count
    end

    def self.generate_message(evaluations)
      participant = evaluations.first.participant
      to_array = []
      merge_vars = []
      evaluations.each do |ev|
        to_array << { "email" => ev.evaluator.email }
        merge_vars << { "rcpt" => ev.evaluator.email,
                        "vars" =>  [{"name" => "EVAL_URL",
                                     "content" => "https://staging-rockwood.herokuapp.com/evaluations/#{ev.access_key}/edit"}]}
      end
      message = {
        "to" => to_array,
        "merge" => true,
        "global_merge_vars" => [{ "name" => "PARTICIPANT_FULL_NAME",
                                  "content" => participant.full_name },
                                { "name" => "PARTICIPANT_FIRST_NAME",
                                  "content" => participant.first_name }],
        "merge_vars" => merge_vars 
      }
      
    end
end

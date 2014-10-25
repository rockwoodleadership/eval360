require 'mandrill'
class EvaluationEmailer

  def self.send_invite_for_self_eval(participant)
    
    
    #todo: use template name from training
    #get training Training.find(participant.training_id)

    template_name = "self-eval-invitation-demo"
    template_content = []
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
    result = mandrill.messages.send_template(template_name, [], message)
    return result.first["status"] 
  end


  def self.send_peer_invites(evaluations)
    participant = evaluations.first.participant
    template_name = "peer-eval-invitation-demo"
    template_content = []
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

  def self.mandrill
    Mandrill::API.new ENV['MANDRILL_APIKEY']
  end
end

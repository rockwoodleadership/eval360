require 'mandrill'
class EvaluationEmailer

  def self.send_invite_for_self(evaluation)
    
    participant = Participant.find(evaluation.participant_id)
    mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    
    #todo: use template name from event
    #get event Event.find(participant.event_id)

    template_name = "self-eval-invitation-demo"
    template_content = []
    message = {
      "subject" => "Welcome to Rockwood Leadership",
      "global_merge_vars" => [{ "name" => "FIRST_NAME",
                                "content" => participant.first_name },
                              { "name" => "LAST_NAME",
                                "content" =>  participant.last_name },
                              { "name" => "EVAL_URL",
                                "content" =>  "https://staging-rockwood.herokuapp.com/evaluations/#{evaluation.access_key}/edit" }],
      "merge" => true,
      "to" => [{ "email" => participant.email, 
                 "name" => "#{participant.first_name} #{participant.last_name}",
                 "type" => "to" }]
      
    }
    result = mandrill.messages.send_template(template_name, [], message)
    return result.first["status"] 
  end
end

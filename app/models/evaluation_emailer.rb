require 'mandrill'
require 'rubygems'
require 'zip'
class EvaluationEmailer

  class << self
    def send_pdf_reports(training_id, email)
      training = Training.find(training_id)
      participants = training.participants
      dir = File.dirname("#{Rails.root}/tmp/pdfs/test")
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      folder = "#{Rails.root}/tmp/pdfs"
      input_filenames = []
      participants.each do |p|
        if p.self_evaluation.completed?
          pdf = ReportPdf.new(p)
          pdf.render_file "#{Rails.root}/tmp/pdfs/#{p.full_name}.pdf"
          input_filenames << "#{p.full_name}.pdf"
        end
      end
      zipfile_name = "#{Rails.root}/tmp/pdfs/#{training_id}.zip"
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, folder + '/' + filename)
        end
      end

      message = {
        "text"=> "Evaluation Reports for #{training.name}",
        "subject"=> "Evaluation Reports for #{training.name}",
        "from_email"=> 'registration@rockwoodleadership.org',
        "to"=> [
          {
            "email"=> email
          }
        ],
        "attachments"=> [
          {
            "type"=> "application/zip",
            "name"=> "#{training_id}.zip",
            "content"=> Base64.encode64(File.open(zipfile_name).read)
          }
        ]
        
      }
      mandrill.messages.send(message)
      FileUtils.rm_rf(dir)
    end
    handle_asynchronously :send_pdf_reports
  end


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
      mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
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

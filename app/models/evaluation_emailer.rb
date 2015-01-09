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

  def self.self_evaluation_reminder(participant)
    training = participant.training
    template_name = "self-reminder-#{training.questionnaire.name}"
    message = generate_participant_message(participant)
    send_template(template_name, message)
  end

  def self.self_evaluation_invite(participant)
    training = participant.training
    template_name = "self-invite-#{training.questionnaire.name}"
    message = generate_participant_message(participant)
    send_template(template_name, message) 
  end


  def self.add_peers_reminder(participant)
    training = participant.training
    template_name = "add-peer-#{training.questionnaire.name}"
    message = generate_participant_message(participant)
    send_template(template_name, message)
  end

  def self.remind_peers_reminder(participant)
    training = participant.training
    template_name = "reminder-to-remind-#{training.questionnaire.name}"
    message = generate_participant_message(participant)
    send_template(template_name, message)
  end


  def self.send_peer_invites(evaluations)
    template_name = "peer-invite-#{evaluations.first.questionnaire.name}"
    message = generate_message(evaluations)
    send_template(template_name, message)
    
  end

  def self.send_peer_reminders(participant, custom_message)
    evaluations = participant.peer_evals_not_completed
    template_name = "peer-reminder-#{participant.training.questionnaire.name}"
    message = generate_message(evaluations)
    if custom_message
      template_name = "#{template_name}-custom"
      message["global_merge_vars"] << { "name" => "CUSTOM_MESSAGE",
                                        "content" => custom_message }
    end
    send_template(template_name, message)
  end

  def self.send_thank_you(evaluation)
    template_name = "peer-thanks-#{evaluation.questionnaire.name}"
    message = generate_message([evaluation])
    send_template(template_name, message)
  end

  def self.send_evaluation_done(participant)
    template_name = "eval-done-#{participant.training.questionnaire.name}"
    message = generate_participant_message(participant)
    send_template(template_name, message)
  end

  private
    def self.base_url
      "https://#{Rails.application.config.action_mailer.default_url_options[:host]}"
    end
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
                                     "content" => "#{base_url}/evaluations/#{ev.access_key}/edit"},
                                    {"name" => "DECLINE_URL",
                                     "content" => "#{base_url}/participants/#{participant.access_key}/peer_decline"}]}
      end
      message = {
        "to" => to_array,
        "merge" => true,
        "global_merge_vars" => [{ "name" => "firstname",
                                  "content" => participant.first_name },
                                { "name" => "lastname",
                                  "content" => participant.last_name },
                                { "name" => "email",
                                  "content" => participant.email },
                                { "name" => "ruby360_Assessment_Deadline_c",
                                  "content" => participant.training.formatted_deadline }],
        "merge_vars" => merge_vars,
        "from_email" => "registration@rockwoodleadership.org",
        "from_name" => "Rockwood Leadership Institute" 
      }
      
    end

    def self.generate_participant_message(participant)
      training = participant.training
      subject = "Welcome to Rockwood's #{training.name} training, #{training.formatted_date}, #{training.city} #{training.state}"
      message = {
        "subject" => subject,
        "global_merge_vars" => [{ "name" => "firstname",
                                  "content" => participant.first_name },
                                { "name" => "lastname",
                                  "content" =>  participant.last_name },
                                { "name" => "ruby360_url__c",
                                  "content" =>  "#{base_url}/evaluations/#{participant.self_evaluation.access_key}/edit" },
                                { "name" => "ruby360_Assessment_Deadline_c",
                                  "content" => training.formatted_deadline },
                                { "name" => "training_curriculum__c",
                                  "content" => training.curriculum },
                                { "name" => "training_site_name_c",
                                  "content" => training.site_name },
                                { "name" => "start_date__c",
                                  "content" => training.formatted_start_date },
                                { "name" => "end_date__c",
                                  "content" => training.formatted_end_date },
                                { "name" => "ruby360_peer_complete_number",
                                  "content" => participant.total_peer_evaluations }],
        "merge" => true,
        "to" => [{ "email" => participant.email, 
                   "name" => "#{participant.first_name} #{participant.last_name}",
                   "type" => "to" }],
        "from_email" => "registration@rockwoodleadership.org",
        "from_name" => "Rockwood Leadership Institute" 
        
      }
    end
end

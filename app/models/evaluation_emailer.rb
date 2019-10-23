require 'mandrill'
require 'rubygems'
require 'zip'
class EvaluationEmailer

  class << self
    def send_pdf_reports(training_id, email)
      training = Training.includes(:participants).find(training_id)
      participants = training.participants
      dir = File.dirname("#{Rails.root}/tmp/pdfs/test")
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      folder = "#{Rails.root}/tmp/pdfs"
      input_filenames = []
      participants.each_with_index do |p,i|
        if p.self_evaluation.completed?
          pdf = ReportPdf.new(p)
          pdf.render_file "#{Rails.root}/tmp/pdfs/#{i}-#{p.full_name}.pdf"
          input_filenames << "#{i}-#{p.full_name}.pdf"
        end
      end
      zipfile_name = "#{Rails.root}/tmp/pdfs/#{training_id}.zip"
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, folder + '/' + filename)
        end
      end

      message = {
        "text"=> "Assessment Reports for #{training.name}",
        "subject"=> "Assessment Reports for #{training.name}",
        "from_email"=> '360@rockwoodleadership.org',
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
      mandrill.messages.send(message, true)
      FileUtils.rm_rf(dir)
    end
    handle_asynchronously :send_pdf_reports
  end

  def self.remind_peers_reminder(participant)
    training = participant.training
    template_name = "reminder-to-remind-#{training.questionnaire.name}"
    message = participant_message(participant)
    message["subject"] = "Rockwood: 360 Leadership Assessment Reminder"
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
    message["subject"] = "Rockwood: Thank You"
    send_template(template_name, message)
  end

  def self.send_evaluation_done(participant)
    template_name = "eval-done-#{participant.training.questionnaire.name}"
    message = participant_message(participant)
    message["subject"] = "Rockwood: 360 Leadership Assessment Complete"
    send_template(template_name, message)
  end

  def self.send_to_participant(template_name, participant)
      message = participant_message(participant)
      send_template(template_name, message)
  end

  private
    def self.base_url
      "http://#{Rails.application.config.action_mailer.default_url_options[:host]}"
    end

    def self.send_template(template_name, message)
      if template_name == 'Public-ProgramsFellowship'
        return
      else
      results = mandrill.messages.send_template(template_name, [], message, true)
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
                                     "content" => "#{base_url}/evaluations/#{ev.access_key}/peer_decline"}]}
      end
      message = {
        "subject" => "#{participant.first_name} #{participant.last_name}'s Leadership Assessment",
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
        "from_email" => "360@rockwoodleadership.org",
        "from_name" => "Rockwood Leadership Institute" 
      }
      
    end

    def self.participant_message(participant)
      training = participant.training
      message = {
        "subject" => "Rockwood: 360 Leadership Assessment" ,
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
                                  "content" => participant.completed_peer_evaluations },
                                { "name" => "city",
                                  "content" => training.city },
                                { "name" => "state",
                                  "content" => training.state }],
        "merge" => true,
        "to" => [{ "email" => participant.email, 
                   "name" => "#{participant.first_name} #{participant.last_name}",
                   "type" => "to" }],
        "from_email" => "360@rockwoodleadership.org",
        "from_name" => "Rockwood Leadership Institute" 
        
      }
    end
end

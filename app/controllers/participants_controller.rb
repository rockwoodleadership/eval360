require 'evaluation_emailer'
class ParticipantsController < ApplicationController
  before_filter { @participant = Participant.find_by_access_key(params[:id]) }

  def invitations
    10.times { @participant.evaluators.build }
    render 'invitations'
  end

  def update
    flash[:errors] = []
    email_hash = params[:participant]['evaluators_attributes']
    existing_emails = @participant.invited_peers.map {|e| e.email}
    emails = [] 
    email_hash.each_value do |attr|
      if attr['email'] == @participant.email
        flash[:errors] << "Can not add self #{attr['email']} as peer evaluator"
      elsif existing_emails.include? attr['email']
        flash[:errors] << "Can not invite #{attr['email']} more than once"
      else
        emails << attr['email'] unless attr['email'].blank?
      end
    end
    if emails.any?
      evaluators = Evaluator.bulk_create(emails)
      evaluations = Evaluation.create_peer_evaluations(evaluators, @participant)
      sent_count = EvaluationEmailer.send_peer_invites(evaluations)
      @participant.added_peer_evaluators
      flash[:notice] = "Thank you. Your invitation(s) have been sent"
    else
      if flash[:errors].empty?
        flash[:errors] << "Must have 1 or more valid emails"
      end
    end
    redirect_to invitations_path(@participant)
  end

  def send_reminders
    sent_count = EvaluationEmailer.send_peer_reminders(@participant, params[:message])
    flash[:notice] = "Thank you. Your peer reminder(s) have been sent"
    render json: "success", status: 200 
  end


  def evaluation_report
    respond_to do |format|
      format.pdf do
        pdf = ReportPdf.new(@participant)
        send_data pdf.render, filename: "#{@participant.full_name}.pdf", type: 'application/pdf'
      end
    end
  end

  

  
end

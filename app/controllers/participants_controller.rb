require 'evaluation_emailer'
class ParticipantsController < ApplicationController
  before_action :find_participant

  def invitations
    10.times { @participant.evaluators.build }
    if flash[:emails]
      flash[:emails].each_with_index do |email, i|
        @participant.evaluators[i].email = email
      end
    end
    render 'invitations'
  end

  def update
    flash[:error] = []
    email_hash = params[:participant]['evaluators_attributes']
    existing_emails = @participant.invited_peers.map {|e| e.email}
    emails = [] 
    email_hash.each_value do |attr|
      if attr['email'] == @participant.email
        flash[:error] << "Can not add self #{attr['email']} as peer evaluator"
      elsif (existing_emails.include? attr['email']) || (emails.include? attr['email'])
        msg = "Can not invite #{attr['email']} more than once"
        flash[:error] << msg unless flash[:error].include? msg
      else
        emails << attr['email'] unless attr['email'].blank?
      end
    end
    if emails.any? && flash[:error].empty?
      evaluators = Evaluator.bulk_create(emails)
      evaluations = Evaluation.create_peer_evaluations(evaluators, @participant)
      sent_count = EvaluationEmailer.send_peer_invites(evaluations)
      @participant.added_peer_evaluators
      flash[:notice] = "Thank you. Your invitation(s) have been sent"
    else
      if flash[:error].empty?
        flash[:error] << "Must have 1 or more valid emails"
      end
    end
    flash[:emails] = email_hash.map {|k,v| v['email']} if flash[:error].any?
    redirect_to invitations_path(@participant)
  end

  def send_reminders
    sent_count = EvaluationEmailer.send_peer_reminders(@participant, params[:message])
    flash[:notice] = "Thank you. Your peer reminder(s) have been sent"
    render json: "success", status: 200 
  end


  def evaluation_report
    if @participant.nil?
      redirect_to :back, notice: "Unable to find that participant" and return
    end
    respond_to do |format|
      format.pdf do
        pdf = ReportPdf.new(@participant)
        send_data pdf.render, filename: "#{@participant.full_name}.pdf", type: 'application/pdf'
      end
    end
  end

  private

  def find_participant
    @participant = Participant.find_by_access_key(params[:id])
  end

  

  
end

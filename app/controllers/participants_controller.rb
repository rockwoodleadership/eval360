require 'evaluation_emailer'
class ParticipantsController < ApplicationController
  before_filter { @participant = Participant.find_by_access_key(params[:id]) }

  def invitations
    8.times { @participant.evaluators.build }
    render 'invitations'
  end

  def update
    if params[:commit] == "Invite Peers"
      evaluators = Evaluator.bulk_create(params[:participant]['evaluators_attributes'])
      evaluations = Evaluation.create_peer_evaluations(evaluators, @participant)
      sent_count = EvaluationEmailer.send_peer_invites(evaluations)
      flash[:notice] = "#{sent_count} invitation(s) sent"
      redirect_to invitations_path(@participant)
    end
  end
  
end

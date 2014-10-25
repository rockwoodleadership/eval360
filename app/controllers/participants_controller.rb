require 'evaluation_emailer'
class ParticipantsController < ApplicationController
  before_filter { @participant = Participant.find_by_access_key(params[:id]) }

  def invitations
    flash[:notice] = "3 invitations sent"
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
  
# {"utf8"=>"✓",
#  "_method"=>"patch",
#  "authenticity_token"=>"XC+yNRPvLkTVqvLIExfDaOPu74ZorbB2lte0UIMYyKU=",
#  "participant"=>
#   {"evaluators_attributes"=>
#     {"0"=>{"email"=>"me@hadiyah.me"},
#      "1"=>{"email"=>"diyahm108@gmail.com"},
#      "2"=>{"email"=>""},
#      "3"=>{"email"=>""},
#      "4"=>{"email"=>""},
#      "5"=>{"email"=>""},
#      "6"=>{"email"=>""},
#      "7"=>{"email"=>""}}},
#  "commit"=>"Invite Peers",
#  "action"=>"update",
#  "controller"=>"participants",
#  "id"=>"3f2dcb67e1bfa501"}

  
end

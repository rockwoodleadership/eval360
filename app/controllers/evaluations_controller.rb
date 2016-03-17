class EvaluationsController < ApplicationController

  def edit
    @evaluation = Evaluation.find_by_access_key(params[:evaluation_id])
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil? || @evaluation.not_accessible?
    completed_self_eval = @evaluation.completed? && @evaluation.self_eval?
    completed_peer_eval = @evaluation.completed? && !@evaluation.self_eval?
    

    if completed_self_eval
      redirect_to invitations_path(@evaluation.participant)
    end

    if completed_peer_eval
      redirect_to thank_you_path
    end

    if !@evaluation.completed?
      render :edit
    end
  end
    

  def update
    evaluation = Evaluation.find_by_access_key(params[:id])
    evaluation.update!(evaluation_params)
    participant = evaluation.participant
    submitting_self_eval = (params[:commit] == "Submit" &&
                            evaluation.self_eval?)
    submitting_peer_eval = (params[:commit] == "Submit" &&
                            !evaluation.self_eval?)
    saving = (params[:commit] == "Save For Later")
    
    unless saving

      if evaluation.answers.joins(:question).where(questions: { answer_type: "numeric" },
                                                   numeric_response: nil).any?
        flash[:error] = ["Please respond to every question"]
        flash[:unanswered] = true
        redirect_to :back  and return
      end
    end

    if submitting_self_eval 
      participant.completed_self_eval
      redirect_to invitations_path participant
    end
    
    if submitting_peer_eval 
      participant.peer_evaluation_completed(evaluation)
      redirect_to thank_you_path
    end

    if saving
      flash[:notice] = "Your responses have been saved"
      redirect_to edit_evaluation_path(evaluation)
    end

  end

  def peer_decline
    evaluation = Evaluation.find_by_access_key(params[:evaluation_id])

    if evaluation
      evaluation.evaluator.decline
      redirect_to peer_decline_path and return
    end

    redirect_to :root
  end
  
  private
    def evaluation_params
      params.require(:evaluation).permit(answers_attributes: [:numeric_response, :text_response, :id])
    end
end

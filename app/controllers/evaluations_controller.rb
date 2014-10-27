class EvaluationsController < ApplicationController

  def edit
    @evaluation = Evaluation.find_by_access_key(params[:evaluation_id])
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil?
    if @evaluation.completed?
      if @evaluation.self_eval?
        redirect_to invitations_path(@evaluation.participant)
      else
        redirect_to thank_you_path
      end
    else
      render :edit
    end

  end

    
    

  def update
    @evaluation = Evaluation.find_by_access_key(params[:id])
    attributes = evaluation_params
    @evaluation.update!(attributes)
    if params[:commit] == "Submit"
      @evaluation.mark_complete 
      if @evaluation.self_eval?
        redirect_to invitations_path(@evaluation.participant) 
      else
        flash[:notice] = "Your evaluation has been saved"
        redirect_to thank_you_path
      end
    elsif params[:commit] == "Save For Later"
      flash[:notice] = "Your responses have been saved"
      redirect_to edit_evaluation_path(@evaluation)
    end
  end
  
  private
    def evaluation_params
      params.require(:evaluation).permit(answers_attributes: [:numeric_response, :text_response, :id])
    end
end

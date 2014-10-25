class EvaluationsController < ApplicationController
  def edit
    @evaluation = Evaluation.find_by_access_key(params[:evaluation_id])
    
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil?
    
    render :edit
  end

  def update
    evaluation = Evaluation.find_by_access_key(params[:id])
    attributes = evaluation_params
    evaluation.update!(attributes)
    evaluation.mark_complete if params[:commit] == "Submit"
    if evaluation.self_eval?
      redirect_to invitations_path(evaluation.participant) 
    end
  end
  
  private
    def evaluation_params
      params.require(:evaluation).permit(answers_attributes: [:numeric_response, :text_response, :id])
    end
end

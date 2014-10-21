class EvaluationsController < ApplicationController
  def edit
    @evaluation = Evaluation.find_by_access_key(params[:evaluation_id])
    
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil?
    
    render :edit
  end
end

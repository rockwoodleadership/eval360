class EvaluationsController < ApplicationController
  def edit
    @evaluation = Evaluation.find_by_access_key(params[:id])
    
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil?

    if @evaluation.questions.empty?
      @evaluation.build_questions
    end
    
    render :edit
  end
end

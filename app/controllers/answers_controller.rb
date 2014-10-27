class AnswersController < ApplicationController

  def update
    answer = Answer.find(params[:answer_id])
    if answer.update!(answer_params)
      render json: 'success', status: 200  
    else
      puts answer.errors
    end

  end

  private

  def answer_params
    params.require(:answer).permit(:numeric_response, :text_response)
  end
end 

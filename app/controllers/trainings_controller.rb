class TrainingsController < ApplicationController

  def email_reports
    EvaluationEmailer.send_pdf_reports(params[:id], params[:email])
    flash[:notice] = "Reports sent to #{params[:email]}"
    render json: "success", status: 200
  end
end

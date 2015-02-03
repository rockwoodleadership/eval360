ActiveAdmin.register Evaluator do
  permit_params :email, :declined
  menu false
  actions :edit, :update, :show, :index
  config.breadcrumb = false

  controller do
    def index
      if params[:id].nil?
        redirect_to admin_root_path and return
      end
      evaluator = Evaluator.find(params[:id])
      participant = evaluator.evaluation.participant
      redirect_to admin_training_participant_path(participant.training, participant)
    end
    def show
      evaluator = Evaluator.find(params[:id])
      participant = evaluator.evaluation.participant
      redirect_to admin_training_participant_path(participant.training, participant)
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :declined, label: "Declined to do a peer assessment (if checked)"
    end
    f.actions 
  end
end

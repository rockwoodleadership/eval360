ActiveAdmin.register Evaluator do
  permit_params :email
  menu false
  actions :edit, :update, :show, :index
  config.breadcrumb = false

  controller do
    def index
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
    f.inputs :email
    f.actions
  end
end

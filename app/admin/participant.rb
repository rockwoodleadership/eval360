ActiveAdmin.register Participant do
  permit_params :training_id, :first_name, :last_name, :email

  actions :index, :show, :edit, :new, :create, :update 

  belongs_to :training
  navigation_menu :default
  menu false 
  config.filters = false
  config.sort_order = "first_name_asc"

  controller do
    defaults finder: :find_by_access_key
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end

  index do
    column "Name" do |participant|
      participant.full_name
    end
    column :email
    column "Self Evaluation Complete" do |participant|
      if participant.self_evaluation
        participant.self_evaluation.completed? ? "Yes" : "No"
      end
    end
    column "Peer Evaluation Status" do |participant|
      participant.peer_evaluation_status
    end
    actions 
  end

  show do |participant|
    attributes_table do
      row :training
      row "Name" do
        participant.full_name
      end
      row :email
      row "self evaluation completed" do
        if participant.self_evaluation
          participant.self_evaluation.completed? ? "Yes" : "No"
        end
      end
      row "self evaluation url" do
        evaluation_edit_url(participant.self_evaluation) if participant.self_evaluation
      end
      row "actions" do
        if participant.self_evaluation.completed?
          link_to("View Self Evaluation", admin_training_participant_evaluation_path(participant.training, participant, participant.self_evaluation)) + " " + link_to("Email Evaluation Invite", send_invite_admin_evaluation_path(participant.self_evaluation)) + " " + link_to("Download Evaluation Report", evaluation_report_participant_path(participant)) 
        else
          link_to("View Self Evaluation", admin_training_participant_evaluation_path(participant.training, participant, participant.self_evaluation)) + " " + link_to("Email Evaluation Invite", send_invite_admin_evaluation_path(participant.self_evaluation))
        end
      end
    end

    panel "Peer Evaluations" do
      table_for participant.peer_evaluations do
        column "Reviewer" do |evaluation|
          evaluation.evaluator.email
        end
        column "Completed" do |evaluation|
          evaluation.completed? ? "Yes" : "No"
        end
        column "Actions" do |evaluation|
          link_to("View", admin_training_participant_evaluation_path(participant.training, participant, evaluation)) if evaluation
        end
      end
    end
    active_admin_comments
  end 

end

ActiveAdmin.register Participant do
  permit_params :training_id, :first_name, :last_name, :email

  actions :index, :show 
  menu priority: 2

  filter :training
  filter :first_name
  filter :last_name
  filter :email
  controller do
    defaults finder: :find_by_access_key
  end
  form do |f|
    f.inputs do
      f.input :training
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end

  index do
    selectable_column
    column "Name" do |participant|
      participant.full_name
    end
    column :email
    column :training
    column :program
    actions
  end


  show do |participant|
    attributes_table do
      row :training
      row "Program" do
        link_to participant.program.name, admin_program_path(participant.training.program)
      end
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
        link_to("View", admin_evaluation_path(participant.self_evaluation)) + " " + link_to("Export PDF", admin_evaluation_path(participant.self_evaluation)) if participant.self_evaluation
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
          link_to("View", admin_evaluation_path(evaluation)) + " " + link_to("Export PDF", admin_evaluation_path(evaluation))  if evaluation
        end
      end
    end
    active_admin_comments
  end 


end

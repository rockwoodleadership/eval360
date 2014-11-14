ActiveAdmin.register Participant do
  permit_params :training_id, :first_name, :last_name, :email

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
      row "self evaluation status" do
        link_to participant.self_evaluation.status, admin_evaluation_path(participant.self_evaluation) if participant.self_evaluation
      end
      row "self evaluation url" do
        evaluation_edit_url(participant.self_evaluation) if participant.self_evaluation
      end
      row "export self evaluation pdf" do
        "PDF"
      end
    end

    panel "Peer Evaluations" do
      table_for participant.peer_evaluations do
        column "Reviewer" do |evaluation|
          evaluation.evaluator.email
        end
        column "Status" do |evaluation|
          evaluation.status
        end
        column "Actions" do |evaluation|
          link_to("View", admin_evaluation_path(evaluation)) + " " + link_to("Export PDF", admin_evaluation_path(evaluation)) if evaluation
        end
      end
    end
    active_admin_comments
  end 


end

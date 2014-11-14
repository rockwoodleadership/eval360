ActiveAdmin.register Training do
  permit_params :name, :program_id, :start_date

  filter :program
  filter :participants
  filter :name
  filter :start_date

  config.sort_order = "start_date_desc"

  index do
    selectable_column
    column :name
    column :start_date
    actions
  end 

  show do |training|
    render "admin/download_reports"
    attributes_table do
      row :program
      row :name
      row :start_date
    end

    panel "Participants" do
      table_for training.participants do
        column "Name" do |participant|
          participant.full_name
        end
        column :email
        column "Self Evaluation" do |participant|
          participant.self_evaluation.status if participant.self_evaluation
        end
        column "Peer Evaluations" do |participant|
          participant.peer_evaluation_status
        end
        column "Actions" do |participant|
          link_to "View", admin_participant_path(participant)
        end
      end
    end

  end


end

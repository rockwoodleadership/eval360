ActiveAdmin.register Training do
  actions :index, :show
  menu priority: 1

  filter :program
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
        column "Self Evaluation Complete" do |participant|
          if participant.self_evaluation
            participant.self_evaluation.completed? ? "Yes" : "No"
          end
        end
        column "Peer Evaluation Status" do |participant|
          participant.peer_evaluation_status
        end
        column "Actions" do |participant|
          link_to "View", admin_participant_path(participant)
        end
      end
    end

  end


end

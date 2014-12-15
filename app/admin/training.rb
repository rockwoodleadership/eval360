ActiveAdmin.register Training do
  permit_params :name, :start_date, :end_date, :location, :questionnaire_id, :status, participants_attributes: [:id, :first_name, :last_name, :email]
  actions :index, :show, :new, :edit, :create, :update
  menu priority: 1

  filter :name
  filter :start_date
  filter :end_date
  filter :location
  filter :status


  config.sort_order = "start_date_desc"

  index do
    selectable_column
    column :name
    column :location
    column "Start Date" do |training|
      training.start_date.strftime("%b %d %Y") if training.start_date
    end
    column "End Date" do |training|
      training.end_date.strftime("%b %d %Y") if training.end_date
    end
    column :status
    actions 
  end 

  form do |f|
    f.inputs "Training Details" do
      f.input :name
      f.input :start_date
      f.input :end_date
      f.input :location
      f.input :status, :as => :select, :collection => ["Planned", "On hold", "In progress", "Completed", "Cancelled"]
      f.input :questionnaire
    end
    f.inputs "Participants" do
      f.has_many :participants, heading: false do |participant|
        participant.inputs do
          participant.input :first_name
          participant.input :last_name
          participant.input :email
        end
      end
    end
    f.actions
  end

  show do |training|
    render "admin/download_reports"
    attributes_table do
      row :name
      row "Start Date" do |training|
        training.start_date.strftime("%b %d %Y") if training.start_date
      end
      row "End Date" do |training|
        training.end_date.strftime("%b %d %Y") if training.end_date
      end
      row :location
      row :status
      row :questionnaire
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
          link_to("View", admin_training_participant_path(training, participant)) + " " + link_to("Edit", edit_admin_training_participant_path(training, participant))
        end
      end
    end

  end


end

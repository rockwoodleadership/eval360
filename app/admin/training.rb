ActiveAdmin.register Training do
  permit_params :name, :start_date, :end_date, :city, :state, :deadline, :curriculum, :site_name, :questionnaire_id, :status, participants_attributes: [:id, :first_name, :last_name, :email]
  actions :index, :show, :new, :edit, :create, :update, :destroy
  menu priority: 1

  filter :name
  filter :start_date
  filter :end_date
  filter :city
  filter :state
  filter :status


  config.sort_order = "start_date_desc"
  config.clear_action_items!

  index do
    column :name
    column "Location" do |training|
      "#{training.city}, #{training.state}"
    end
    column "Start Date" do |training|
      training.start_date.strftime("%b %d %Y") if training.start_date
    end
    column "End Date" do |training|
      training.end_date.strftime("%b %d %Y") if training.end_date
    end
    column :status
    column "Actions" do |training|
      link_to "View", admin_training_path(training)
    end 
    div do
      link_to "create new training", new_admin_training_path, class: "small-new"
    end
  end

  form(:html => { :multipart => true}) do |f|
    f.inputs "WARNING" do
      f.render partial: "admin/warning"
    end 
    f.inputs "Training Details" do
      f.input :name
      f.input :start_date
      f.input :end_date
      f.input :city
      f.input :state
      f.input :status, :as => :select, :collection => ["Planned", "On hold", "In progress", "Completed", "Cancelled"]
      f.input :questionnaire
      f.input :curriculum
      f.input :deadline
      f.input :site_name
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
      row "Location" do
        "#{training.city}, #{training.state}"
      end
      row :status
      row "Deadline" do
        training.deadline.strftime("%b %d %Y") if training.deadline
      end
      row :curriculum
      row :site_name
      row "Assessment" do
        training.questionnaire
      end
    end

    panel "Participants" do
      table_for training.participants do
        column "Name" do |participant|
          participant.full_name
        end
        column :email
        column "Self Assessment Complete" do |participant|
          if participant.self_evaluation
            participant.self_evaluation.completed? ? "Yes" : "No"
          end
        end
        column "Peer Assessment Status" do |participant|
          participant.peer_evaluation_status
        end
        column "Actions" do |participant|
          link_to("View", admin_training_participant_path(training, participant)) 
        end
      end
    end

    div do
      link_to "Download Participant Self Scores and Avg Scores", admin_training_participants_path(training, format: :csv)
    end

    div do
      link_to "Edit Training", edit_admin_training_path(training)
    end
    div do
      link_to("Delete Training", admin_training_path(training), data: { confirm: "WARNING: Are you sure you want to delete this training?" }, method: :delete)
    end

  end


end

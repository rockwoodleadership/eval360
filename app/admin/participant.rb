ActiveAdmin.register Participant do
  permit_params :training_id, :first_name, :last_name, :email, :do_not_remind

  actions :index, :show, :edit, :new, :create, :update, :destroy 

  belongs_to :training
  navigation_menu :default
  menu false 
  config.filters = false
  config.sort_order = "first_name_asc"
  config.clear_action_items!

  controller do
    defaults finder: :find_by_access_key

    def update
      participant = Participant.find_by(access_key: params[:id])
      participant.update(permitted_params[:participant]) 
      flash[:notice] = "Participant has been updated"
      redirect_to admin_training_participant_path(participant.training, participant)
    end

    def destroy
      participant = Participant.find_by(access_key: params[:id])
      participant.destroy 
      flash[:notice] = "Participant has been removed"
      redirect_to admin_training_participants_path(participant.training)
    end

  end

  member_action :remind, method: :get do
    participant = Participant.find_by_access_key(params[:id])
    if participant.remind
      flash[:notice] = "Reminder sent"
    else
      flash[:notice] = "Error sending reminder"
    end
    redirect_back fallback_location: root_path 
  end

  member_action :remind_peers, method: :get do
    participant = Participant.find_by_access_key(params[:id])
    participant.remind_to_remind_peers
    flash[:notice] = "Reminder sent"
    
    redirect_back fallback_location: root_path
  end

  member_action :download_evaluators, method: :get do
    participant = Participant.find_by_access_key(params[:id])
    send_data participant.reviewers_to_csv,
      filename: "reviewers_for_#{participant.full_name.downcase.tr(' ','_')}.csv"

  end

  csv do
    column :first_name
    column :last_name
    column :email
    column "Self Assessment Complete" do |participant|
      if participant.self_evaluation
        participant.self_evaluation.completed? ? "Yes" : "No"
      end
    end
    column "Peer Assessment Status" do |participant|
      participant.peer_evaluation_status
    end
    column "Participant URL" do |participant|
      evaluation_edit_url(participant.self_evaluation) if participant.self_evaluation 
    end
  end

  form do |f|
    template.render partial: "admin/warning"
    inputs do
      input :do_not_remind
      input :first_name
      input :last_name
      input :email
      input :training
      #, :as => :select, :collection => Training.all.map{|b| [b.name,b.id]}
    end
    actions
  end

  index do
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
    actions 
  end

  show do |participant|
    attributes_table do
      row :training
      row "Name" do
        participant.full_name
      end
      row :email
      row "self assessment completed" do
        if participant.self_evaluation
          participant.self_evaluation.completed? ? "Yes" : "No"
        end
      end
      row "self assessment url" do
        evaluation_edit_url(participant.self_evaluation) if participant.self_evaluation
      end
      row "Remind" do 
        participant.do_not_remind? ? "Does not receive reminders" : "Receives reminders" 
      end
      row "actions" do
        if participant.self_evaluation
          links =  link_to("View Self Assessment", admin_training_participant_evaluation_path(training, participant, participant.self_evaluation))
          if participant.self_evaluation.completed?
            if (participant.completed_peer_evaluations < 10 && participant.peer_evaluators.count >= 0)
              links += link_to("Download Assessment Report", evaluation_report_participant_path(participant))
              links += link_to("Send Remind Peers Reminder", remind_peers_admin_training_participant_path(training, participant))
            else
              links += link_to("Download Assessment Report", evaluation_report_participant_path(participant))
            end

          else
            links += link_to("Email Assessment Reminder", remind_admin_training_participant_path(training, participant))
          end
        end

      end
    end

    panel "Peer Assessment" do
      table_for participant.peer_evaluations do
        column "Reviewer" do |evaluation|
          evaluation.evaluator.email
        end
        column "Completed" do |evaluation|
          if evaluation
            evaluation.completed? ? "Yes" : "No"
          end
        end
        column "Actions" do |evaluation|
          if evaluation
           link_to("View", admin_training_participant_evaluation_path(participant.training, participant, evaluation)) + " " + link_to("Edit Email Address", edit_admin_evaluator_path(evaluation.evaluator)) + " " + link_to("Delete Peer Assessment", admin_training_participant_evaluation_path(participant.training, participant, evaluation), data: { confirm: "Are you sure you want to delete this peer assessment?" }, method: :delete)
          end

        end
      end

      if participant.declined_peers.any?
        table_for participant.declined_peers do
          column "Declined Reviewer" do |evaluator|
            evaluator.email
          end
          column "Actions" do |evaluator|
            link_to "Reinstate", edit_admin_evaluator_path(evaluator)
          end
        end
      end
      

    end
    active_admin_comments
    div do
      link_to("Download Peer Assessment Status as CSV", download_evaluators_admin_training_participant_path(training, participant, format: 'csv'))
    end
    div do
      link_to("Edit Participant", edit_admin_training_participant_path(training, participant))
    end
    div do
      link_to("Delete Participant", admin_training_participant_path(participant.training, participant), data: { confirm: "WARNING: Are you sure you want to delete this participant?" }, method: :delete)
    end
    div do
      link_to("View Assessment Report", participant_report_path(participant), target: :blank)
    end
  end
end

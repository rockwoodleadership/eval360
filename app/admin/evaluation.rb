ActiveAdmin.register Evaluation do
  controller do
    defaults finder: :find_by_access_key
    belongs_to :training do
      belongs_to :participant, finder: :find_by_access_key, parent_class: :training 
    end
  end

  config.filters = false
  navigation_menu :default

  actions :all, :except => [:new, :edit]
  menu false

  breadcrumb do
    links = [
              link_to('Admin', admin_root_path),
              link_to('Trainings', admin_trainings_path),
              link_to(training.name, admin_training_path(training)),
              link_to('Participants', admin_training_participants_path(training)),
              link_to(participant.full_name, admin_training_participant_path(training,participant))
            ]
    if controller.action_name == 'show'
      links << link_to('Assessments', admin_training_participant_evaluations_path(training, participant))
    end
    links
  end

  config.sort_order = 'created_at_asc'

  

  member_action :reopen_evaluation, method: :get do
    evaluation = Evaluation.find_by_access_key(params[:id])
    evaluation.completed = false
    evaluation.save
    flash[:notice] = "Assessment has been reopened"
    redirect_to :back
  end

  index do 
    selectable_column
    column "Evaluator" do |evaluation|
      evaluation.evaluator.email
    end
    column "Participant" do |evaluation|
      evaluation.participant.full_name
    end
    column "Type" do |evaluation|
      evaluation.eval_type_str
    end
    column :completed do |evaluation|
      evaluation.completed? ? "Yes" : "No"
    end
    column :updated_at
    actions
  end

  show :title => proc { |evaluation| evaluation.eval_type_str } do |evaluation|
    panel "Assessment Details" do
      attributes_table_for evaluation do
        row "Type" do
          evaluation.self_eval? ? "Self Assessment" : "Peer Assessment"
        end
        row :participant do
          link_to participant.full_name, admin_training_participant_path(training, participant)
        end
        row :evaluator
        row :completed do
          evaluation.completed? ? "Yes" : "No"
        end
        row "Assessment Url" do
          evaluation_edit_url(evaluation)
        end
        row "Actions" do
          if evaluation.completed?
            link_to("Reopen Assessment", reopen_evaluation_admin_evaluation_path(evaluation))
          end
        end
      end
    end

    panel "Assessment Responses" do
      evaluation.answers.includes(:question).each_with_index do |answer, i|
        if evaluation.self_eval?
          h5 "#{i+1}. #{answer.question.self_description}"
        else
          h5 "#{i+1}. #{answer.question.description}"
        end 
        div :class => "response" do
          answer.response 
        end
      end
    end
  end

end

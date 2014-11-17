ActiveAdmin.register Evaluation do
  controller do
    defaults finder: :find_by_access_key
  end

  filter :evaluator_email_in, :as => :string, label: "Evaluator Email", :collection => proc { Evaluator.all.map(&:email) }
  filter :participant
  filter :completed

  actions :all, :except => [:new, :edit]
  menu priority: 3

  member_action :send_invite, method: :get do
    evaluation = Evaluation.find_by_access_key(params[:id])
     if evaluation.email_to_evaluator
       flash[:notice] = "Invite sent"
     else
       flash[:notice] = "Error sending invite"
     end

     redirect_to :back 
  end

  member_action :reset_evaluation, method: :get do
    evaluation = Evaluation.find_by_access_key(params[:id])
    evaluation.reset_values
    flash[:notice] = "Evaluation has been reset"
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
      if evaluation.self_eval?
        "Self Evaluation"
      else
        "Peer Evaluation"
      end
    end
    column :completed
    column :updated_at
    actions
  end

  show :title => proc { |evaluation| evaluation.eval_type_str + " for " + evaluation.participant.full_name } do |evaluation|
    attributes_table do
      row :participant do
        link_to evaluation.participant.full_name, admin_participant_path(evaluation.participant)
      end
      row :evaluator
      row :completed
      row "Type" do
        if evaluation.self_eval?
          "Self Evaluation"
        else
          "Peer Evaluation"
        end
      end
      row "Evaluation Url" do
        evaluation_edit_url(evaluation)
      end
      row "Actions" do
        link_to "Resend Evaluation Invite", send_invite_admin_evaluation_path(evaluation)
      end
    end
    panel "Evaluation Responses" do
      evaluation.answers.each do |answer|
        if evaluation.self_eval?
          h5 answer.question.self_description
        else
          h5 answer.question.description
        end 
        div :class => "response" do
          answer.response 
        end
      end
      div do
        link_to "Reset Evaluation Responses", reset_evaluation_admin_evaluation_path(evaluation), data: { confirm: "Are you sure you want to reset the response?" }
      end

    end
  end




end
